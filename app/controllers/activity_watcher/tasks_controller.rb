class ActivityWatcher::TasksController < ActivityWatcher::BaseController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :get_tasks_select, only: [:new, :create]

  def index
    @course = Course.find_by(id: params[:course_id])
    @tasks = @course.tasks.order(id: :desc).page(params[:page])
  end
  
  def list
    @tasks = Task.get_list(params[:course_id]).page(params[:page])
  end

  def show
    if @task.blank?
      respond_to do |format|
        format.html {render text: "リクエストされたURLは存在しません", layout: "activity_watcher/base", status: "404"}
      end
    return
    end
  end
  
  def detail
    @teams = Task.get_teams_list(current_user.id, params[:id]).page(params[:page])
  end

  def new
    @task = Task.new()
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.course_id = params[:course_id]

    if params[:task][:check_take_over] == "true"
      @task.team_ids = TaskTeam.where(task_id: params[:task][:before_task_id]).pluck(:team_id)
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to _course_tasks_url(@task.course_id), notice: '課題の作成が完了しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to _course_tasks_url(@task.course_id), notice: '課題の修正が完了しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
        format.html { redirect_to _course_tasks_url(@task.course_id), notice: '課題の削除が完了しました' }
    end
  end

  private
  
  def get_tasks_select
    @task_select = Task.where(course_id: params[:course_id]).order(id: :desc).pluck(:title, :id)
  end
  
  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :start_date, :end_date, :description, :slack_domain,
                                 :check_take_over, :before_task_id)
  end
end
