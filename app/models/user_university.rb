class UserUniversity < ApplicationRecord
  belongs_to :user, inverse_of: :user_universities
  belongs_to :university
  
  before_validation :create_confirmation_token
  
  validates :university_id,
    uniqueness: { scope: [:user_id] }
    
  validates :email,
    presence: true,
    uniqueness: { allow_blank: true },
    length: { maximum: 128}
  
  validate :email_domain_valid
  
  validates :student_no,
    presence: true,
    uniqueness: { scope: [:university_id], allow_blank: true },
    length: { maximum: 64 }, if: :is_student?
    
  scope :email_unconfirmed, -> { where(email_confirmed_flg: false) }

  def email_domain_valid
    return if email.blank?
    email_domain = University.find_by(id: university_id).email_domain
    valid_email_domain = /\A[\w+-.]+@#{email_domain}\z/
    unless email.match(valid_email_domain)
      errors.add(:email, "は正しいアドレスではありません")
    end
  end
  
  private
  
  def create_confirmation_token
    return if email.blank?
    self.confirmation_token = Digest::SHA1.hexdigest(email)
  end
  
  def is_student?
    user.authority == "Student"
  end

end
