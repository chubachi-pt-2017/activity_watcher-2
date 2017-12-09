class Course < ApplicationRecord
  has_many :tasks, dependent: :destroy, inverse_of: :course
  has_many :users, through: :course_participants
  has_many :course_participants, dependent: :destroy, inverse_of: :course

  validates :title,
    presence: true,
    uniqueness: {allow_blank: true},
    length: {maximum: 50, allow_blank: true}
  
  validates :student_entry_start,
    presence: true

  validates :student_entry_end,
    presence: true
  
  validate :validate_start_end_date
  
  validate :validate_start_date_before_today, if: :check_entry_date_changed?
  
  validate :validate_end_date, if: :check_entry_end_changed?
  
  class << self
    def get_list(user_id, university_id)
      course_participants = CourseParticipant.where(user_id: user_id)
      Course.joins("LEFT JOIN (#{course_participants.to_sql}) cp ON courses.id = cp.course_id").select("courses.*, cp.user_id").where(
        university_id: university_id).order(id: :desc)
    end
  
    def create_participant(course_id, user_id)
      cp = CourseParticipant.find_or_initialize_by(course_id: course_id, user_id: user_id)
      if cp.new_record?
        return false if cp.invalid?
        cp.save
      end
      true
    end

  end
  
  private
  
  def time_current
    Time.current.beginning_of_day
  end
  
  def check_entry_end_changed?
    student_entry_end_changed?
  end
  
  def check_entry_date_changed?
    student_entry_start_changed?
  end
  
  def validate_start_end_date
    errors.add(:student_entry_end, "は開始日より前にはできません") if student_entry_start > student_entry_end
  end
  
  def validate_end_date
    errors.add(:student_entry_end, "は今日以降の日付にしてください") if student_entry_end < time_current
  end
  
  def validate_start_date_before_today
    errors.add(:student_entry_start, "は今日以降の日時を指定してください") if time_current > student_entry_start
  end
end
