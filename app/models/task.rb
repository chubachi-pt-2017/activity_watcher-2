class Task < ApplicationRecord
  belongs_to :course, inverse_of: :tasks
  has_many :teams, through: :task_teams
  has_many :task_teams, dependent: :destroy, inverse_of: :task
  has_many :own_join, class_name: Task, primary_key: 'id', foreign_key: 'reference_task_id'
  accepts_nested_attributes_for :task_teams
  
  before_save :create_task_teams
  
  validates :title,
    presence: true,
    uniqueness: { scope: [:course_id], allow_blank: true },
    length: {maximum: 50, allow_blank: true}
    
  validates :start_date,
    presence: true

  validates :end_date,
    presence: true
  
  validate :validate_start_end_date
  
  validate :validate_start_date_before_today, if: :check_date_changed?
  
  validate :validate_end_date_before_today, if: :check_end_date_changed?
  
  scope :get_index, ->(course_id) { includes(:own_join).where(course_id: course_id)
                                  .select_status_word.order(updated_at: :desc) }
  
  scope :get_list, ->(course_id) { where(course_id: course_id)
                                  .select_status.select_status_word.order("status ASC, end_date ASC") }
  
  scope :get_select_item, ->(course_id, task_id = nil) { where(course_id: course_id, reference_task_id: nil)
                                         .where.not(id: task_id).order(id: :desc).pluck(:title, :id) }
  
  scope :get_reference_task_ids, ->(task_id) { where(reference_task_id: task_id).order(:id).pluck(:id) }
  
  scope :get_has_reference_task_title, ->(task_id) { where(reference_task_id: task_id).order(:id).pluck(:title)}

  scope :select_status, -> {
    current_time = Time.current
    scope = current_scope || relation
    scope = scope.select("*") if scope.select_values.blank?
    scope.select("(CASE WHEN tasks.start_date <= '#{current_time}' AND tasks.end_date >= '#{current_time}' THEN 0
                       WHEN tasks.start_date > '#{current_time}' THEN 1
                       WHEN tasks.end_date < '#{current_time}' THEN 2 END) AS status")
  }

  scope :select_status_word, -> {
    current_time = Time.current
    scope = current_scope || relation
    scope = scope.select("*") if scope.select_values.blank?
    scope.select("(CASE WHEN tasks.start_date <= '#{current_time}' AND tasks.end_date >= '#{current_time}' THEN '受付中'
                       WHEN tasks.start_date > '#{current_time}' THEN '開始待ち'
                       WHEN tasks.end_date < '#{current_time}' THEN '受付終了' END) AS status_word")
  }

  class << self
    def included_in_the_team(task_id, user_id)
      team_ids = TaskTeam.where(task_id: task_id).pluck(:team_id)
      TeamParticipant.where(team_id: team_ids, user_id: user_id).count > 0 ? true : false
    end
    
    def get_by_id(task_id)
      select("id, title")
      .where(id: task_id)
    end
    
  end
  
  def create_task_teams
    # レコード更新でかつチーム構成参照元の課題が変更されていたら現行の紐付きを解除
    if !self.new_record? && self.reference_task_id_changed?
      if self.reference_task_id_was == nil
        # 独自チーム構成の課題からの変更でチームが既に作成済みだったら削除
        team_ids = TaskTeam.where(task_id: self.id).pluck(:team_id)
        Team.destroy_all(id: team_ids) if team_ids.length > 0
      end
      TaskTeam.destroy_all(task_id: self.id)
    end
    
    # チーム構成参照元の課題に値があれば、その課題と同じチーム構成の紐付きを生成
    if self.reference_task_id_changed? && self.reference_task_id.present?
      self.team_ids = TaskTeam.where(task_id: self.reference_task_id).order(:id).pluck(:team_id)
    end
  end
  
  def clear_reference_task(reference)
    return false if reference != 'clear'
    self.reference_task_id = nil
    self.save
    true
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
