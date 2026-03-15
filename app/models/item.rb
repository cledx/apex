class Item < ApplicationRecord
  belongs_to :house
  has_many :want_to_buys, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true, length: { minimum: 5 }
  validates :price, format: { with: /\A\d+(\.\d{1,2})?\z/ }
