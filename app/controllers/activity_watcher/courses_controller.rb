class ActivityWatcher::CoursesController < ActivityWatcher::BaseController
  before_action :get_time_current, only: [:list, :detail]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :detail, :entry]
  before_action :get_university_name, only: [:show, :detail]
  before_action :get_user_slacks_new_select, only: [:new, :create]
  before_action :get_user_slacks_edit_select, only: [:edit, :update]
  before_action :get_user_slack, only: [:show, :detail]
  before_action :get_all_universities, only: [:new, :edit, :create, :update]

  def index
    @courses = Course.get_index(current_user.id).page(params[:page])
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
    @course = Course.new(university_id: session[:university_id])
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    @course.owner_id = current_user.id

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

  private
  
  def get_all_universities
    @universities = University.order(:id).pluck(:name, :id)
  end
  
  def get_time_current
    @time_current = Time.current
  end
  
  def get_university_name
    @university_name = University.find_by(id: @course.university_id).name
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
    params.require(:course).permit(:title, :start_date, :end_date, :description, :user_slack_id, :university_id, :publish_other_universities_flg)
  end
  
end
