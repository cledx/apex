class WantToBuy < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates :notes, length: { maximum: 1000 }, allow_blank: true
end
