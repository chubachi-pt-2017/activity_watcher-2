class UserSlack < ApplicationRecord
  belongs_to :user
  has_one :course, inverse_of: :user_slack
  
  before_save do
    self.url = "https://#{domain}.slack.com/" if self.url.blank?
  end
  
  validates :domain,
    presence: true,
    length: {maximum: 128, allow_blank: true}
  
  validates :token,
    presence: true,
    length: {maximum: 256, allow_blank: true}
  
  scope :get_user_slacks_list, ->(user_id) { includes(:course).where(user_id: user_id).references(:course).order(id: :desc) }
  scope :get_user_slacks_select, ->(user_id, course_id = nil) { includes(:course).where(user_id: user_id)
                                   .where(courses: {id: [nil, course_id]}).order(id: :desc).pluck(:domain, :id) }
  
  class << self
    def create_user_slack(auth, user_id)
      user_slack = UserSlack.find_or_initialize_by(
        token: auth['credentials']['token'],
        domain: auth['extra']['raw_info']['team_info']['team']['domain'],
        user_id: user_id)
      if user_slack.new_record?
        return false if user_slack.invalid?
        user_slack.save
      end
      true
    end
  end
end
