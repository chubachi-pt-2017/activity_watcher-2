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
                                  .select_status_word
                                  .where(owner_id: owner_id)
                                  .order(updated_at: :desc) }

  scope :get_select_non_user_slacks, ->(user_id) {
                              where(owner_id: user_id, user_slack_id: [nil, 0]).order(id: :desc).pluck(:title, :id)}
  
  scope :select_status, -> {
    current_time = Time.current
    scope = current_scope || relation
    scope = scope.select("*") if scope.select_values.blank?
    scope.select("(CASE WHEN courses.start_date <= '#{current_time}' AND courses.end_date >= '#{current_time}' THEN 0
                       WHEN courses.start_date > '#{current_time}' THEN 1
                       WHEN courses.end_date < '#{current_time}' THEN 2 END) AS status")
  }

  scope :select_status_word, -> {
    current_time = Time.current
    scope = current_scope || relation
    scope = scope.select("*") if scope.select_values.blank?
    scope.select("(CASE WHEN courses.start_date <= '#{current_time}' AND courses.end_date >= '#{current_time}' THEN '受講可能'
                       WHEN courses.start_date > '#{current_time}' THEN '開始待ち'
                       WHEN courses.end_date < '#{current_time}' THEN '受付終了' END) AS status_word")
  }

  class << self
    def get_list(user_id, university_id)
      course_participants = CourseParticipant.where(user_id: user_id)
      Course.joins("LEFT JOIN (#{course_participants.to_sql}) cp ON courses.id = cp.course_id LEFT JOIN universities u ON courses.university_id = u.id").select("courses.*, cp.user_id, u.name AS university_name")
        .select_status.select_status_word
        .where("courses.university_id = ? or courses.publish_other_universities_flg = true", university_id)
        .order("status ASC, end_date ASC")
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
