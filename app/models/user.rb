class User < ApplicationRecord
  
  has_many :universities, through: :user_universities
  has_many :user_universities, dependent: :destroy, inverse_of: :user
  has_many :course_participants, dependent: :destroy
  has_many :teams, through: :team_participants
  has_many :team_participants, dependent: :destroy
  has_many :user_slacks, dependent: :destroy
  accepts_nested_attributes_for :user_universities, allow_destroy: true
  
  include ActiveRecord::Confirmable
  
  enum authority: { Student: 1, Teacher: 2 }
  
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
  
  def update_oauth_token(auth)
    self.oauth_token = auth['credentials']['token']
    self.save
  end
  
  def user_registration_context
    validation_context == :user_registration
  end
  
  def user_registration_context_is_student
    user_registration_context && is_student?
  end
  
  def user_registration_context_is_not_student
    user_registration_context && is_teacher?
  end
  
  def is_student?
    authority == "Student"
  end
  
  def is_teacher?
    authority == "Teacher"
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
    user_universities.each_with_index do |user_university, i|
      next if user_university.valid?
      
      user_university.errors.full_messages.each do |full_message|
        errors.add(:user_universities, "#{(i + 1).to_s}件目の#{full_message}")
      end
      
      user_university.errors.clear
    end
  end
  
  # 子モデル項目の一括登録時ユニーク確認用method
  def validate_user_universities_uniqueness
    university_ids = []
    emails = []
    user_universities.each do |user_university|
      university_ids.push(user_university.university_id)
      emails.push(user_university.email)
    end
    result_university = university_ids.group_by{ |arr| arr }.reject{ |k, v| v.one? }.keys
    result_email = emails.group_by{ |arr| arr }.reject{ |k, v| v.one? }.keys.reject(&:blank?)
    errors.add(:user_universities, "の所属大学が重複しています") if result_university.length > 0
    errors.add(:user_universities, "のメールアドレスが重複しています") if result_email.length > 0
  end
  
end
