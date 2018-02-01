class Team < ApplicationRecord
  has_many :tasks, through: :task_teams
  has_many :task_teams, dependent: :destroy, inverse_of: :team
  has_many :users, through: :team_participants
  has_many :team_participants, dependent: :destroy, inverse_of: :team
  accepts_nested_attributes_for :task_teams, allow_destroy: true
  accepts_nested_attributes_for :team_participants, allow_destroy: true
  
  before_save do
    # updateでかつメンバーが変更されていたら一旦全メンバーを削除
    unless self.new_record?
      participants = TeamParticipant.where(team_id: self.id).order(:user_id).pluck(:user_id)
      if self.user_ids.sort_by { |user_id| user_id } != participants
        TeamParticipant.destroy_all(team_id: self.id)
      end
    end
  end
  
  validates :name,
    presence: true,
    uniqueness: { allow_blank: true },
    length: { maximum: 20, allow_blank: true }
  
  validates :description,
    length: { maximum: 256, allow_blank: true }
  
  scope :get_teams_list_with_user, ->(task_id) {includes([:tasks, :users]).where(tasks: {id: task_id}).order(id: :desc)}
  
  class << self
    def get_all_member_list(course_id, task_id)
      user_ids = User.includes(teams: :tasks).where(tasks: {id: task_id}).pluck(:id)
      User.includes(:course_participants)
                  .where(course_participants: {course_id: course_id})
                  .where.not(id: user_ids).order(:user_full_name, :login_name).pluck(:user_full_name, :login_name, :id)
                  .map{|a, b, c| [a + '(' + b + ')', c]}
    end
    
    def get_included_member_in_the_team(course_id, team_id)
      user_ids = TeamParticipant.where(team_id: team_id).pluck(:user_id)
      User.where(id: user_ids).order(:user_full_name, :login_name).pluck(:user_full_name, :login_name, :id)
                  .map{|a, b, c| [a + '(' + b + ')', c]}
    end
  end
  
  private
  
end
