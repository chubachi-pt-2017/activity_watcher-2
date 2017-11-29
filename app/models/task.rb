class Task < ApplicationRecord
  belongs_to :course, inverse_of: :tasks
  
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
