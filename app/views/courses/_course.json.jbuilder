json.extract! course, :id, :title, :student_entry_start, :student_entry_end, :description, :created_at, :updated_at
json.url course_url(course, format: :json)