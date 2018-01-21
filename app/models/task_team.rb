class TaskTeam < ApplicationRecord
  belongs_to :task, inverse_of: :task_teams
  belongs_to :team, inverse_of: :task_teams
  
  VALID_REPOSITORY_NAME = //
  validates :repository_name,
    presence: true,
    length: { maximum: 256, allow_blank: true },
    format: { with: VALID_REPOSITORY_NAME, message: "は(アカウント名またはorganization)/リポジトリ名の形式で入力してください", allow_blank: true }, on: [:new_team, :update]
  
  validates :service_url,
    length: { maximum: 256, allow_blank: true }
  
  validates :ci_url,
    length: { maximum: 256, allow_blank: true }
  
  scope :get_tasks_lists_from_team, ->(team_id) {includes(:task).where(team_id: team_id).order(id: :desc)}
  
  private
  
end
