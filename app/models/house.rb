class House < ApplicationRecord
  US_ADDRESS_FORMAT = /\A(\d+\s+[\w\s.,'-]+|P\.?\s*O\.?\s*Box\s+\d+[\w\s.,'-]*)\z/i

  has_many :items, dependent: :destroy
  has_many_attached :photos

  validates :address,
            presence: true,
            format: {
              with: US_ADDRESS_FORMAT,
              message: "must be a valid US address (e.g. 123 Main St or P.O. Box 456)"
            }

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  validates :owner, presence: true

  validates :name,
            length: { maximum: 255 },
            allow_blank: true

  def soft_delete
    if update(deleted_at: Time.current)
      true
    else
      false
    end
  end

  # Public listing: show the real address once the sale start is on or before
  # (today + 2 calendar days), or once the sale has already started (start_date in the past).
  def address_publicly_visible?
    start_date <= Time.zone.today + 2.days && start_date > Time.zone.today - 2.days
  end

  def past_sale?
    start_date < Time.zone.today - 2.days
  end

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?
    return if end_date >= start_date

    errors.add(:end_date, "must be on or after the start date")
  end
end
