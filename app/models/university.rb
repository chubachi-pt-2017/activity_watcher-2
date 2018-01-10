class University < ApplicationRecord
  has_many :user_universities, dependent: :destroy
  has_many :users, through: :user_universities
  
  validates :name,
    presence: true,
    uniqueness: true,
    length: { maximum: 30, allow_blank: true }
  
  validates :name_en,
    presence: true,
    uniqueness: true,
    length: { maximum: 50, allow_blank: true }
  
  validates :email_domain,
    presence: true,
    uniqueness: true,
    length: { maximum: 64, allow_blank: true }
end
