class TaskTeam < ApplicationRecord
  belongs_to :task
  belongs_to :team
  
  validates :repository_name,
    presence: true,
    length: { maximum: 128, allow_blank: true }
  
  validates :service_url,
    length: { maximum: 256, allow_blank: true }
  
  validates :ci_url,
    length: { maximum: 256, allow_blank: true}
end
