class Item < ApplicationRecord
  belongs_to :house

  validates :name, presence: true, length: { minimum: 5 }
  validates :price, numericality: { greater_than: 0 }
end
