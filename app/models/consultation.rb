class Consultation < ApplicationRecord
  scope :open, -> { where(deleted_at: nil, closed_at: nil) }
  scope :visible, -> { where(deleted_at: nil) }

  validates :client_name, :email, presence: true, on: :create

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create

  validates :address, presence: true

  validates :phone_number, presence: true
  validate :phone_number_must_have_10_digits

  validates :details,
            presence: true,
            length: { minimum: 60 },
            on: :create

  def soft_delete
    if update(deleted_at: Time.current)
      true
    else
      false
    end
  end

  private

  def phone_number_must_have_10_digits
    return if phone_number.blank?

    digit_count = phone_number.gsub(/\D/, "").length
    return if digit_count == 10

    errors.add(:phone_number, "must contain exactly 10 digits")
  end
end

