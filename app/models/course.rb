class Course < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :title,
    presence: true,
    uniqueness: {allow_blank: true},
    length: {maximum: 128, allow_blank: true}
  
  validates :student_entry_start,
    presence: true

  validates :student_entry_end,
    presence: true
  
  validates :description,
    length: {maximum: 256, allow_blank: true}
  
  validate :validate_start_end_date
  
  validate :validate_start_date_before_today
  
  private
  
  def validate_start_end_date
    errors.add(:student_entry_end, "は開始日より前にはできません") if student_entry_start > student_entry_end
  end
  
  def validate_start_date_before_today
    errors.add(:student_entry_start, "は今日以降の日時を指定してください") if Time.current.beginning_of_day > student_entry_start
  end
end
