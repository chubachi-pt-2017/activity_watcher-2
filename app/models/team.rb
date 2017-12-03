class Team < ApplicationRecord
  has_many :tasks, through: :task_teams
  has_many :task_teams, dependent: :destroy, inverse_of: :team
  accepts_nested_attributes_for :task_teams, allow_destroy: true
  accepts_nested_attributes_for :team_participants, allow_destroy: true
  
  validates :name,
    presence: true,
    uniqueness: { allow_blank: true },
    length: { maximum: 64, allow_blank: true }
  
  validates :description,
    length: { maximum: 256, allow_blank: true }
end
