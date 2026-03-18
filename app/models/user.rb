class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :role, inclusion: { in: %w[admin customer manager] }

  def manager?
    if role == "manager" || role == "admin"
      true
    else
      false
    end
  end

  def admin?
    if role == "admin"
      true
    else
      false
    end
  end

  def customer?
    if role == "customer"
      true
    else
      false
    end
  end

end
