class ActivityWatcher::CoursesController < ActivityWatcher::BaseController
  before_action :get_time_current, only: [:list, :detail]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :detail]

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
        if params[:participate]
          notice = 'コースへの参加を取り消しました'
        else
          notice = 'コースへの参加登録が完了しました'
        end
        format.html { redirect_to list_courses_url, notice: notice }
      else
        format.html { render action: 'list' }
      end
    end
  end

  private
  
  def get_time_current
    @time_current = Time.current
  end

  def set_course
    @course = Course.find_by(id: params[:id])
  end
  
  def course_params
    params.require(:course).permit(:title, :start_date, :end_date, :description)
  end
  
end
