class UserSlack < ApplicationRecord
  belongs_to :user
  has_one :course, inverse_of: :user_slack
  
  before_save do
    self.url = "https://#{domain}.slack.com/" if self.url.blank?
  end
  
  scope :get_user_slacks_list, ->(user_id) { includes(:course).where(user_id: user_id).references(:course).order(id: :desc) }
  scope :get_user_slacks_select, ->(user_id, course_id = nil) { includes(:course).where(user_id: user_id)
                                   .where(courses: {id: [nil, course_id]}).order(id: :desc).pluck(:workspace_name, :id) }
  
  class << self
    def create_user_slack(auth, user_id)
      user_slack = UserSlack.find_or_initialize_by(
        workspace_name: auth['extra']['raw_info']['team_info']['team']['name'],
        token: auth['credentials']['token'],
        domain: auth['extra']['raw_info']['team_info']['team']['domain'],
        user_id: user_id)
      if user_slack.new_record?
        user_slack.save
      end
      true
    end
    
    def collaborate_course(course_id, user_slack_id)
      course = Course.find_by(id: course_id)
      course.user_slack_id = user_slack_id
      return false unless course.save
      true
    end
  end
end
