class Task < ApplicationRecord
  belongs_to :course, inverse_of: :tasks
  has_many :teams, through: :task_teams
  has_many :task_teams, dependent: :destroy, inverse_of: :task
  
  validates :title,
    presence: true,
    uniqueness: {allow_blank: true},
    length: {maximum: 50, allow_blank: true}
    
  validates :start_date,
    presence: true

  validates :end_date,
    presence: true
  
  validates :description,
    length: {maximum: 256, allow_blank: true}
    
  validates :slack_domain,
    presence: true,
    uniqueness: {allow_blank: true},
    length: {maximum: 128, allow_blank: true}
    
  validate :validate_start_end_date
  
  validate :validate_start_date_before_today, if: :check_date_changed?
  
  scope :get_list, ->(course_id) { where("course_id = ? and start_date < ?", course_id, Time.current).order(id: :desc) }
  
  class << self
    def get_teams_list(user_id, task_id)
      team_participants = TeamParticipant.where(user_id: user_id)
      Team.joins("LEFT JOIN (#{team_participants.to_sql}) tp ON teams.id = tp.team_id LEFT JOIN task_teams tt ON tp.team_id = tt.team_id LEFT JOIN tasks ON tt.task_id = tasks.id")
        .select("teams.*, tp.user_id").where("tasks.id = ?", task_id).order(id: :desc)
    end
  end
  
  private
  
  def check_date_changed?
    start_date_changed? || end_date_changed?
  end
  
  def validate_start_end_date
    errors.add(:end_date, "は開始日より前にはできません") if start_date > end_date
  end
  
  def validate_start_date_before_today
    errors.add(:start_date, "は今日以降の日時を指定してください") if Time.current.beginning_of_day > start_date
  end
end
