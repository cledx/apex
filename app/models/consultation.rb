class Consultation < ApplicationRecord
  US_ADDRESS_FORMAT = House::US_ADDRESS_FORMAT

  validates :address,
            presence: true,
            format: {
              with: US_ADDRESS_FORMAT,
              message: "must be a valid US address (e.g. 123 Main St or P.O. Box 456)"
            }

  validates :phone_number, presence: true
  validate :phone_number_must_have_10_digits

  validates :details,
            presence: true,
            length: { minimum: 60 }

  private

  def phone_number_must_have_10_digits
    return if phone_number.blank?

    digit_count = phone_number.gsub(/\D/, "").length
    return if digit_count == 10

    errors.add(:phone_number, "must contain exactly 10 digits")
  end
end

