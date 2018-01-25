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
  link "#{course.title.truncate(20)}の詳細", course_path(course)
  parent :courses
end

# courses#new
crumb :new_courses do
  link "コースの新規作成", new_course_path
  parent :courses
end

# courses#edit
crumb :edit_course do |course|
  link "#{course.title.truncate(20)}の編集", edit_course_path(course)
  parent :course, course
end

# courses#list
crumb :list_courses do
  link "開講コース一覧", list_courses_path
  parent :root
end

# courses#detail
crumb :detail_course do |course|
  link "#{course.title.truncate(20)}の詳細", detail_course_path(course)
  parent :list_courses
end

# tasks#index
crumb :tasks do |course|
  link "#{course.title.truncate(20)}の課題一覧", _course_tasks_path(course)
  parent :course, course
end

# tasks#show
crumb :task do |course, task|
  link "#{task.title.truncate(20)}の詳細", _course_task_path(course, task)
  parent :tasks, course
end

# tasks#new
crumb :new_tasks do |course|
  link "課題の新規作成", new__course_task_path(course)
  parent :tasks, course
end

# tasks#edit
crumb :edit_task do |course, task|
  link "#{task.title.truncate(20)}の編集", edit__course_task_path(course, task)
  parent :task, course, task
end

# tasks#list
crumb :list_tasks do |course|
  link "#{course.title.truncate(20)}の課題一覧", list__course_tasks_path(course)
  parent :detail_course, course
end

# tasks#detail
crumb :detail_task do |course, task|
  link "#{task.title.truncate(20)}の詳細", detail__course_task_path(course, task)
  parent :list_tasks, course
end

# teams#show
crumb :team do |course, task, team|
  link "#{team.name.truncate(20)}の詳細", _course_task_team_path(course, task, team)
  parent :detail_task, course, task
end

# teams#new
crumb :new_teams do |course, task|
  link "チームの新規作成", new__course_task_team_path(course, task)
  parent :detail_task, course, task
end

# teams#edit
crumb :edit_team do |course, task, team|
  link "#{team.name.truncate(20)}の編集", edit__course_task_team_path(course, task, team)
  parent :team, course, task, team
end

# task_teams#edit
crumb :edit_task_team do |course, task, team, task_team|
  link "課題「#{task.title.truncate(20)}」の成果物を編集", edit__course_task_team_task_team_path(course, task, team, task_team)
  parent :team, course, task, team
end

# user_slacks#index
crumb :user_slacks do
  link "Slackの管理", slack_index_path
  parent :root
end

# universities#index
crumb :universities do
  link "大学情報の管理", universities_path
  parent :root
end
