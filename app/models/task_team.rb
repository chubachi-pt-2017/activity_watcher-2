class TaskTeam < ApplicationRecord
  belongs_to :task
  belongs_to :team
end
