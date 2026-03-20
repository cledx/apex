class Consultation < ApplicationRecord
  scope :open, -> { where(deleted_at: nil, closed_at: nil) }
  scope :visible, -> { where(deleted_at: nil) }
  scope :awaiting_contact, -> { open.where(contacted_at: nil) }

  validates :client_name, presence: true, on: :create

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            allow_blank: true,
            on: :create

  validates :address, presence: true

  validate :email_or_phone_present
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

  def email_or_phone_present
    return if email.present? || phone_number.present?

    errors.add(:base, "Please provide an email address or phone number.")
  end

  def phone_number_must_have_10_digits
    return if phone_number.blank?

    digit_count = phone_number.gsub(/\D/, "").length
    return if digit_count == 10

    errors.add(:phone_number, "must contain exactly 10 digits")
  end
end

