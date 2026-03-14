class Item < ApplicationRecord
  belongs_to :house
  has_many :want_to_buys, dependent: :destroy

  validates :name, presence: true, length: { minimum: 5 }
  validates :price, numericality: { greater_than: 0 }

  
end
