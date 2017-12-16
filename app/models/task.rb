class Task < ApplicationRecord
  belongs_to :course, inverse_of: :tasks
  has_many :teams, through: :task_teams
  has_many :task_teams, dependent: :destroy, inverse_of: :task
  accepts_nested_attributes_for :task_teams
  
  attr_accessor :check_take_over, # チームを引き継ぐか否かのチェックボックス値
                :before_task_id   # 引継ぎ元の課題ID
  
  validates :title,
    presence: true,
    uniqueness: {allow_blank: true},
    length: {maximum: 50, allow_blank: true}
    
  validates :start_date,
    presence: true

  validates :end_date,
    presence: true
  
  validates :slack_domain,
    presence: true,
    uniqueness: {allow_blank: true},
    length: {maximum: 128, allow_blank: true}
    
  validate :validate_start_end_date
  
  validate :validate_start_date_before_today, if: :check_date_changed?
  
  validate :validate_end_date_before_today, if: :check_end_date_changed?
  
  scope :get_index, ->(course_id) { where(course_id: course_id).order(updated_at: :desc) }
  
  scope :get_list, ->(course_id) { where("course_id = ? and start_date < ?", course_id, Time.current).order(id: :desc) }
  
  scope :get_select_item, ->(course_id) { where(course_id: course_id).order(id: :desc).pluck(:title, :id) }

  class << self
    def included_in_the_team(task_id, user_id)
      team_ids = TaskTeam.where(task_id: task_id).pluck(:team_id)
      count = TeamParticipant.where(team_id: team_ids, user_id: user_id).count
      count > 0 ? true : false
    end
  end
  
  private
  
  def time_current
    Time.current.beginning_of_day
  end
  
  def check_date_changed?
    start_date_changed?
  end
  
  def check_end_date_changed?
    end_date_changed?
  end
  
  def validate_start_end_date
    errors.add(:end_date, "は開始日より前にはできません") if start_date > end_date
  end
  
  def validate_end_date_before_today
    errors.add(:end_date, "は今日以降の日時を指定してください") if time_current > end_date
  end

  def validate_start_date_before_today
    errors.add(:start_date, "は今日以降の日時を指定してください") if time_current > start_date
  end
end
