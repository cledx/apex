require "test_helper"

class HouseTest < ActiveSupport::TestCase
  setup do
    @attrs = {
      address: "123 Main St, Springfield, IL 62701",
      owner: "Owner",
      start_date: Date.new(2026, 4, 1),
      end_date: Date.new(2026, 4, 2)
    }
  end

  test "address_publicly_visible? is false when sale starts more than 2 calendar days from today" do
    travel_to Time.zone.parse("2026-03-21 12:00") do
      house = House.new(@attrs.merge(start_date: Date.new(2026, 3, 25)))
      assert_not house.address_publicly_visible?
    end
  end

  test "address_publicly_visible? is true on the cutoff day (today + 2 days)" do
    travel_to Time.zone.parse("2026-03-21 12:00") do
      house = House.new(@attrs.merge(start_date: Date.new(2026, 3, 23)))
      assert house.address_publicly_visible?
    end
  end

  test "address_publicly_visible? is true when sale already started" do
    travel_to Time.zone.parse("2026-03-21 12:00") do
      house = House.new(@attrs.merge(start_date: Date.new(2026, 3, 10)))
      assert house.address_publicly_visible?
    end
  end
end
