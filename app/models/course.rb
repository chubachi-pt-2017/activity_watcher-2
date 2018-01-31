class Course < ApplicationRecord
  has_many :tasks, dependent: :destroy, inverse_of: :course
  has_many :users, through: :course_participants
  has_many :course_participants, dependent: :destroy, inverse_of: :course
  belongs_to :user_slack, inverse_of: :course
  belongs_to :university, inverse_of: :courses

  validates :title,
    presence: true,
    uniqueness: {allow_blank: true},
    length: {maximum: 50, allow_blank: true}
  
  validates :start_date,
    presence: true

  validates :end_date,
    presence: true
  
  validate :validate_start_end_date
  
  validate :validate_start_date_before_today, if: :check_start_date_changed?
  
  validate :validate_end_date, if: :check_end_date_changed?
  
  scope :get_index, ->(owner_id) { includes([:user_slack, :university, :tasks])
                                  .add_status_column
                                  .where(owner_id: owner_id)
                                  .order(updated_at: :desc) }

  scope :get_select_non_user_slacks, ->(user_id) {
                              where(owner_id: user_id, user_slack_id: [nil, 0]).order(id: :desc).pluck(:title, :id)}
  
  scope :add_status_column, ->(user_id = nil) {
    current_time = Time.current
    scope = current_scope || relation
    scope = scope.select("courses.*") if scope.select_values.blank?
    if user_id.blank?
      scope.select("(CASE WHEN courses.start_date <= '#{current_time}' AND courses.end_date >= '#{current_time}' THEN 0
                         WHEN courses.start_date > '#{current_time}' THEN 1
                         WHEN courses.end_date < '#{current_time}' THEN 2 END) AS status")
    else
      scope.select("(CASE WHEN courses.start_date <= '#{current_time}' AND courses.end_date >= '#{current_time}' AND
                         cp.cp_user_ids @> ARRAY[#{user_id}] THEN 0
                         WHEN courses.start_date <= '#{current_time}' AND courses.end_date >= '#{current_time}' AND
                         (not(cp.cp_user_ids @> ARRAY[#{user_id}]) OR cp.cp_user_ids IS NULL) THEN 1
                         WHEN courses.start_date > '#{current_time}' THEN 2
                         WHEN courses.end_date < '#{current_time}' AND cp.cp_user_ids @> ARRAY[#{user_id}] THEN 3
                         WHEN courses.end_date < '#{current_time}' AND (not(cp.cp_user_ids @> ARRAY[#{user_id}]) OR cp.cp_user_ids IS NULL) THEN 4 END) AS status")
    end
  }

  class << self
    def get_list(user_id, university_id)
      cp = CourseParticipant.group(:course_id).select("course_participants.course_id, array_agg(course_participants.user_id) AS cp_user_ids")
      Course.joins("LEFT JOIN (#{cp.to_sql}) cp ON courses.id = cp.course_id LEFT JOIN universities u ON courses.university_id = u.id LEFT JOIN user_slacks us ON courses.user_slack_id = us.id LEFT JOIN users ON courses.owner_id = users.id")
        .select("courses.*, cp.cp_user_ids, u.name AS university_name, us.workspace_name, us.url AS slack_url, users.user_full_name AS owner_name")
        .add_status_column(user_id)
        .where("courses.university_id = ? or courses.publish_other_universities_flg = true", university_id)
        .order("status ASC, courses.end_date ASC")
    end
  
    def create_or_destroy_participant(course_id, user_id, participate = nil)
      cp = CourseParticipant.find_or_initialize_by(course_id: course_id, user_id: user_id)
      if cp.new_record?
        return false if cp.invalid?
        cp.save
      elsif participate.present? && participate == "cancel"
        cp.destroy
      end
      true
    end

  end
  
  private
  
  def time_current
    Time.current.beginning_of_day
  end
  
  def check_start_date_changed?
    start_date_changed?
  end
  
  def check_end_date_changed?
    end_date_changed?
  end
  
  def validate_start_end_date
    errors.add(:end_date, "は開始日より前にはできません") if start_date > end_date
  end
  
  def validate_end_date
    errors.add(:end_date, "は今日以降の日付にしてください") if end_date < time_current
  end
  
  def validate_start_date_before_today
    errors.add(:start_date, "は今日以降の日時を指定してください") if time_current > start_date
  end
end
