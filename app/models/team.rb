class Team < ApplicationRecord
  has_many :tasks, through: :task_teams
  has_many :task_teams, dependent: :destroy, inverse_of: :team
  has_many :users, through: :team_participants
  has_many :team_participants, dependent: :destroy, inverse_of: :team
  accepts_nested_attributes_for :task_teams, allow_destroy: true
  accepts_nested_attributes_for :team_participants, allow_destroy: true
  
  paginates_per 5 # 一覧の表示件数
  
  validates :name,
    presence: true,
    uniqueness: { allow_blank: true },
    length: { maximum: 64, allow_blank: true }
  
  validates :description,
    length: { maximum: 256, allow_blank: true }
  
  validate :validate_participants_uniquness, on: :update
  
  scope :get_teams_list_with_user, ->(task_id) {includes([:tasks, :users]).where(tasks: {id: task_id}).order(id: :desc)}
  
  class << self
    def get_new_member_list(course_id, task_id)
      user_ids = User.includes(teams: :tasks).where(tasks: {id: task_id}).pluck(:id)
      User.includes(:course_participants)
                  .where(course_participants: {course_id: course_id})
                  .where.not(id: user_ids).order(:login_name).pluck(:login_name, :id)
    end
    
    def get_included_member_in_the_team(course_id, team_id)
      user_ids = TeamParticipant.where(team_id: team_id).pluck(:user_id)
      User.where(id: user_ids).order(:login_name).pluck(:login_name, :id)
    end
  end
  
  private
  
  def validate_participants_uniquness
    array_tp = team_participants.pluck(:user_id)
    result_tp = array_tp.group_by{ |arr| arr }.reject{ |k, v| v.one? }.keys
    errors.add(:team_participants, "が重複しています") if result_tp.length > 0
  end
  
end
