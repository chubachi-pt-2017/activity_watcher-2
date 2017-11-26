class Course < ApplicationRecord
  has_many :tasks

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
  
  validate :validate_start_date_before_now
  
  private
  
  def validate_start_end_date
    errors.add(:student_entry_end, "は開始日より前には設定できません") if student_entry_start > student_entry_end
  end
  
  def validate_start_date_before_now
    errors.add(:student_entry_start, "は現在日時より以前には設定できません") if Time.zone.now > student_entry_start
  end
end
