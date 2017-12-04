class ActivityWatcher::CoursesController < ActivityWatcher::BaseController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.where(owner_id: current_user.id, university_id: session[:university_id]).order(id: :asc)
  end
  
  def list
    @courses = Course.get_list(session[:user_id], session[:university_id])
  end

  def show
    if @course.blank?
      respond_to do |format|
        format.html {render text: "リクエストされたURLは存在しません", layout: "activity_watcher/base", status: "404"}
      end
    end
    return
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
        format.html { redirect_to @course, notice: 'コースの更新が完了しました' }
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
      if Course.create_participant(params[:id], session[:user_id])
        format.html { redirect_to list_courses_url, notice: 'コースへの参加登録が完了しました' }
      else
        format.html { render action: 'list' }
      end
    end
  end

  private

  def set_course
    @course = Course.find_by(id: params[:id])
  end
  
  def course_params
    params.require(:course).permit(:title, :student_entry_start, :student_entry_end, :description)
  end
end
