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
    length: { maximum: 256, allow_blank: true }
  
  scope :get_tasks_lists_from_team, ->(team_id) {includes(:task).where(team_id: team_id).order(id: :desc)}
  
  class << self
    def get_repository_name(task_id)
      select("id, repository_name")
      .where(task_id: task_id)
    end
  end

  private
  
end
