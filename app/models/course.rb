class Course < ApplicationRecord
      validates :course_name, presence: true, uniqueness: true
end
