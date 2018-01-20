class ActivityWatcher::CoursesController < ActivityWatcher::BaseController
  
  SEVEN_DAYS = 7
  FOURTEEN_DAYS = 14

  before_action :get_time_current, only: [:list, :detail]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :detail, :entry, :show_team_detail]
  before_action :get_user_slacks_new_select, only: [:new, :create]
  before_action :get_user_slacks_edit_select, only: [:edit, :update]
  before_action :get_user_slack, only: [:show, :detail]

  def index
    @courses = Course.get_index(current_user.id, session[:university_id]).page(params[:page])
  end
  
  def list
    @courses = Course.get_list(current_user.id, session[:university_id]).page(params[:page])
  end

  def show
    if @course.blank?
      respond_to do |format|
        format.html {render text: "リクエストされたURLは存在しません", layout: "activity_watcher/base", status: "404"}
      end
      return
    end
  end
  
  def detail
    @participant = CourseParticipant.find_by(course_id: params[:id], user_id: current_user.id)
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    @course.owner_id = current_user.id
    @course.university_id = session[:university_id]

    respond_to do |format|
      if @course.save
        format.html { redirect_to courses_url, notice: 'コースの登録が完了しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to courses_url, notice: 'コースの更新が完了しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'コースの削除が完了しました' }
    end
  end
  
  def entry
    respond_to do |format|
      if Course.create_or_destroy_participant(params[:id], current_user.id, params[:participate])
        if params[:participate] == "cancel"
          notice = 'コースへの参加を取り消しました'
        else
          notice = 'コースへの参加登録が完了しました'
          if @course.user_slack_id.present?
            slack = SlackManager.new(@course.user_slack.token)
            slack.send_invite_email(current_university.email)
          end
        end
        format.html { redirect_to list_courses_url, notice: notice }
      else
        format.html { render action: 'list' }
      end
    end
  end

  def show_team_detail
    @task = Task.get_by_id(7).first #task ID
    repos = TaskTeam.get_repository_name(7) #task ID
    @github_data_pcercents = Hash.new { |h,k| h[k] = {} }

    # ここでキャッシュからデータ取得
    
    if repos[0].repository_name.present?
      githubManager = GithubManager.new(ENV["GITHUB_ACCESS_TOKEN"])

      @contributors = githubManager.get_contributors_for_the_repository(repos[0].repository_name)

      # 先週のコミット数取得、先々週のコミット数取得
      @commits_last_week = githubManager.get_commits_between_weeks(repos[0].repository_name, SEVEN_DAYS)
      @commits_two_weeks_ago = githubManager.get_commits_between_weeks(repos[0].repository_name, FOURTEEN_DAYS)
      calculate_percent_for_compared_weeks(@commits_last_week, @commits_two_weeks_ago, "commit")

      # 先週マージされたpull request数取得、先々週マージされたpull request数取得
      @merged_pull_request_last_week = githubManager.get_merged_pull_requests_between_weeks(repos[0].repository_name, SEVEN_DAYS)
      @merged_pull_request_two_weeks_ago = githubManager.get_merged_pull_requests_between_weeks(repos[0].repository_name, FOURTEEN_DAYS)
      calculate_percent_for_compared_weeks(@merged_pull_request_last_week, @merged_pull_request_two_weeks_ago, "merged_pull_request")

      # 先週のメンバーへのコメント数取得、先々週のメンバーへのコメント数取得
      @pull_request_comments_last_week = githubManager.get_pull_request_comments_between_weeks(repos[0].repository_name, SEVEN_DAYS)
      @pull_request_comments_two_weeks_ago = githubManager.get_pull_request_comments_between_weeks(repos[0].repository_name, FOURTEEN_DAYS)
      calculate_percent_for_compared_weeks(@pull_request_comments_last_week, @pull_request_comments_two_weeks_ago, "comments_to_pull_request")
    end
# raise @commits_two_weeks_ago.has_key?(16436985).inspect
    # @commit_percent = (@commits_last_week[12966035].to_f() / @commits_two_weeks_ago[12966035].to_f() * 100).round(2)

    # raise @github_data_pcercents.inspect
    # raise @github_data_pcercents["commit"].inspect
    # raise @commits_two_weeks_ago[16436985].to_.inspect
    # raise (( (@commits_last_week[16436985].to_f() / @commits_two_weeks_ago[16436985].to_f() * 100).round(2) ) - 100).inspect
    @user_full_name = User.get_member_full_name(@contributors.keys)
    # raise @github_data_pcercents.inspect
  end

  private

  def calculate_percent_for_compared_weeks(last_week, two_weeks_ago, github_action)
    @contributors.each do |key, member|
      if (last_week[key].present? && two_weeks_ago[key].present?)
        @github_data_pcercents[github_action][key] = ( (last_week[key].to_f() / two_weeks_ago[key].to_f() * 100).round(2) ) - 100
      else
        @github_data_pcercents[github_action][key] = "-"
      end
    end
  end

  def get_time_current
    @time_current = Time.current
  end
  
  def get_user_slacks_new_select
    @user_slacks = UserSlack.get_user_slacks_select(current_user.id)
  end

  def get_user_slacks_edit_select
    @user_slacks = UserSlack.get_user_slacks_select(current_user.id, params[:id])
  end
  
  def get_user_slack
    @user_slack = UserSlack.find_by(id: @course.user_slack_id)
  end

  def set_course
    @course = Course.find_by(id: params[:id])
  end
  
  def course_params
    params.require(:course).permit(:title, :start_date, :end_date, :description, :user_slack_id, :team_id)
  end
  
end
