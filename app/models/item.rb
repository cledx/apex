class Item < ApplicationRecord
  belongs_to :house
  has_many :want_to_buys, dependent: :destroy
  has_many_attached :photos

  validates :name, presence: true, length: { minimum: 5 }
  validates :price, format: { with: /\A\d+(\.\d{1,2})?\z/, allow_blank: true }

  def soft_delete
    if update(deleted_at: Time.current)
      true
    else
      false
    end
  end

  def is_favourite?(user)
    WantToBuy.exists?(item: self, user: user)
  end

  def add_to_favourite(user)
    if is_favourite?(user)
      return false
    else
      WantToBuy.create(item: self, user: user)
      return true
    end
  end

  def remove_from_favourite(user)
    if is_favourite?(user)
      if WantToBuy.find_by(item: self, user: user).destroy
        return true
      else
        return false
      end
    else
      return false
    end
  end

end
