class TeamParticipant < ApplicationRecord
  belongs_to :team
  belongs_to :user
  
  validates :user_id, presence: true, uniqueness: { scope: [:team_id], allow_blank: true }
end
