class User < ApplicationRecord
  
  has_many :universities, through: :user_universities
  has_many :user_universities, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :user_universities, allow_destroy: true
  
  include ActiveRecord::Confirmable
  
  enum authority: { Student: 1, Teacher: 2, Reviewer: 3 }
  
  attr_accessor :teachers_password   #教職員用の認証パスワード(テーブルには存在しない)
  
  with_options if: :user_registration_context do
    validates :user_full_name,
      presence: true,
      length: { maximum: 64 }
      
    validates :slack_user, 
      presence: true,
      length: { maximum: 64 }
      
    validate :validate_user_universities_uniqueness
    
    validate :validate_user_universities
  end
  
  with_options if: :user_registration_context_is_not_student do
    validate :teachers_password_valid
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.login_provider = auth['provider']
      user.uid = auth['uid']
      user.login_name = auth['info']['nickname']
      user.oauth_token = auth['credentials']['token']
    end
  end
  
  def user_registration_context
    validation_context == :user_registration
  end
  
  def user_registration_context_is_student
    user_registration_context && is_student?
  end
  
  def user_registration_context_is_not_student
    user_registration_context && (is_teacher? || is_reviewer?)
  end
  
  def is_student?
    authority == "Student"
  end
  
  def is_teacher?
    authority == "Teacher"
  end
  
  def is_reviewer?
    authority == "Reviewer"
  end
  
  def teachers_password_valid
    if teachers_password.blank?
      errors.add(:teachers_password, "を入力してください")
    elsif teachers_password != ENV['TEACHERS_PASSWORD']
      errors.add(:teachers_password, "が正しくありません")
    end
  end
  
  private
  
  # 子モデルのバリデーションメソッド(配列の要素ごとにエラーメッセージを表示するため、親モデルで定義)
  def validate_user_universities
    count = 0
    user_universities.each do |user_university|
      count += 1
      next if user_university.valid?
      
      user_university.errors.full_messages.each do |full_message|
        errors.add(:user_universities, "#{count.to_s}件目の#{full_message}")
      end
      
      user_university.errors.clear
    end
  end
  
  # 子モデル項目の一括登録時ユニーク確認用method
  def validate_user_universities_uniqueness
    a_university_id = []
    a_email = []
    user_universities.each do |user_university|
      a_university_id.push(user_university.university_id)
      a_email.push(user_university.email)
    end
    r_university_id = a_university_id.group_by{ |arr| arr }.reject{ |k, v| v.one? }.keys
    r_email = a_email.group_by{ |arr| arr }.reject{ |k, v| v.one? }.keys.reject(&:blank?)
    errors.add(:user_universities, "の所属大学が重複しています") if r_university_id.length > 0
    errors.add(:user_universities, "のメールアドレスが重複しています") if r_email.length > 0
  end
  
end
