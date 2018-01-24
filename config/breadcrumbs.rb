# homes#index
crumb :root do
  link "ホーム", activity_watcher_path
end

# courses#index
crumb :courses do
  link "#{current_user.user_full_name}さんのコース一覧", courses_path
  parent :root
end

# courses#show
crumb :course do |course|
  link "#{course.title}の詳細", course_path(course)
  parent :courses
end

# courses#new
crumb :new_courses do
  link "コースの新規作成", new_course_path
  parent :courses
end

# courses#edit
crumb :edit_course do |course|
  link "#{course.title}の編集", edit_course_path(course)
  parent :courses
end

# courses#list
crumb :list_courses do
  link "開講コース一覧", list_courses_path
  parent :root
end

# tasks#index
crumb :tasks do |course|
  link "#{course.title}の課題一覧", _course_tasks_path(course)
  parent :courses
end

