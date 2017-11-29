class University < ApplicationRecord
  has_many :user_universities, dependent: :destroy
  has_many :users, through: :user_universities
end
