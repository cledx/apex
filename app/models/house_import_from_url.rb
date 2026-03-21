# frozen_string_literal: true

require "cgi"
require "json"
require "open-uri"
require "nokogiri"
require "stringio"

# Imports an EstateSales.NET (and similar) listing page: builds a House from JSON-LD + HTML,
# then creates one Item per gallery photo with the image attached.
class HouseImportFromUrl
  USER_AGENT = "Mozilla/5.0 (compatible; ApexEstateImport/1.0; +https://example.com)".freeze

  def initialize(url)
    @url = url.to_s.strip
  end

  def call
    raise ArgumentError, "URL is required" if @url.blank?

    uri = URI.parse(@url)
    raise ArgumentError, "http or https URL required" unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

    html = fetch_html(uri)
    doc = Nokogiri::HTML(html)
    ld = extract_sale_event_json_ld(html)
    raise "Could not find sale metadata (JSON-LD SaleEvent) on this page." if ld.blank?

    house = House.new(
      name: ld["name"].presence,
      address: address_from_json_ld(ld) || address_from_maps_link(doc),
      owner: ld.dig("organizer", "name").presence || "Unknown organizer",
      start_date: date_from_iso(ld["startDate"]),
      end_date: date_from_iso(ld["endDate"])
    )

    ActiveRecord::Base.transaction do
      house.save!
      import_gallery_items(doc, house)
    end

    house
  end

  private

  def fetch_html(uri)
    URI.open(uri.to_s, "User-Agent" => USER_AGENT, read_timeout: 45, open_timeout: 15, &:read)
  end

  def extract_sale_event_json_ld(html)
    html.scan(%r{<script type="application/ld\+json">(.*?)</script>}m).each do |(fragment)|
      data = JSON.parse(fragment)
      type = data["@type"]
      next unless type == "SaleEvent" || (type.is_a?(Array) && type.include?("SaleEvent"))

      return data
    rescue JSON::ParserError
      next
    end
    nil
  end

  def address_from_json_ld(ld)
    loc = ld["location"]
    return nil unless loc.is_a?(Hash)

    addr = loc["address"]
    if addr.is_a?(Hash)
      street = addr["streetAddress"].to_s.strip
      city = addr["addressLocality"].to_s.strip
      region = addr["addressRegion"].to_s.strip
      zip = addr["postalCode"].to_s.strip
      region_zip = [region, zip].reject(&:blank?).join(" ")
      line = [street, city, region_zip].reject(&:blank?).join(", ")
      return line if line.present?
    end

    loc["name"].to_s.presence
  end

  def address_from_maps_link(doc)
    anchor = doc.at_css('a[href*="maps.google.com/maps?q="]')
    return nil unless anchor

    href = anchor["href"].to_s
    uri = URI.parse(href)
    q = CGI.parse(uri.query.to_s)["q"]&.first
    if q.present?
      CGI.unescape(q.to_s).tr("+", " ")
    else
      anchor.text.strip.gsub(/\s+/, " ")
    end
  end

  def date_from_iso(value)
    return nil if value.blank?

    Time.zone.parse(value.to_s).to_date
  end

  def import_gallery_items(doc, house)
    doc.css("app-traditional-sale-view-picture-gallery .sale-picture-gallery__thumbnail a.sale-picture-gallery__wrap").each do |link|
      picture_id = link["href"].to_s[/picture=(\d+)/, 1]
      next if picture_id.blank?

      src = link.at_css("source[lazyload]")&.[]("lazyload").to_s.strip
      next if src.blank?

      item = house.items.build(
        name: "Listing photo #{picture_id}",
        category: "Estate sale",
        price: nil
      )
      item.save!
      attach_remote_photo(item, src)
    end
  end

  def attach_remote_photo(item, image_url)
    uri = URI.parse(image_url)
    filename = File.basename(uri.path.presence || "photo.jpg")
    # Read into memory: passing a block to URI.open closes the stream before ActiveStorage finishes.
    data = URI.open(uri.to_s, "User-Agent" => USER_AGENT, read_timeout: 60, open_timeout: 15, &:read)
    item.photos.attach(io: StringIO.new(data), filename: filename)
  rescue StandardError => e
    Rails.logger.warn("HouseImportFromUrl: photo attach failed #{image_url}: #{e.message}")
  end
end
