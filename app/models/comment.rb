class Comment < ApplicationRecord
   validates_presence_of :from, :body
   belongs_to :task
end
