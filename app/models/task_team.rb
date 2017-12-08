class TaskTeam < ApplicationRecord
  belongs_to :task, inverse_of: :task_teams
  belongs_to :team, inverse_of: :task_teams
  
  paginates_per 5 # 一覧の表示件数
  
  validates :repository_name,
    presence: true,
    length: { maximum: 128, allow_blank: true }, on: [:new_team, :update]
  
  validates :service_url,
    length: { maximum: 256, allow_blank: true }
  
  validates :ci_url,
    length: { maximum: 256, allow_blank: true}
  
  private
  
end
