class University < ApplicationRecord
  has_many :user_universities, dependent: :destroy
  has_many :users, through: :user_universities
  has_many :courses, inverse_of: :university
  
  paginates_per 20 # 一覧の表示件数
  
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
