class ActivityWatcher::TasksController < ActivityWatcher::BaseController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :detail, :reference]
  before_action :get_course, only: [:index, :list, :show, :detail, :new, :edit, :create, :update]
  before_action :get_tasks_new_select, only: [:new, :create]
  before_action :get_tasks_edit_select, only: [:edit, :update]
  before_action :get_has_reference_task_title, only: [:show, :edit]

  def index
    @tasks = Task.get_index(params[:course_id]).page(params[:page])
  end
  
  def list
    @tasks = Task.get_list(params[:course_id], current_user.id).page(params[:page])
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
    @teams = Team.get_teams_list_with_user(params[:id]).page(params[:page])
    @included = Task.included_in_the_team(params[:id], current_user.id)
  end

  def new
    @task = Task.new()
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.course_id = params[:course_id]

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
  
  def reference
    respond_to do |format|
      if @task.clear_reference_task(params[:reference])
        format.html { redirect_to _course_tasks_url(@task.course_id), notice: 'チーム構成の参照を解除しました'}
      else
        format.html { redirect_to _course_tasks_url(@task.course_id), notice: 'チーム構成の参照解除に失敗しました'}
      end
    end
  end

  private
  
  def get_course
    @course = Course.find_by(id: params[:course_id])
  end
  
  def get_tasks_new_select
    @task_select = Task.get_select_item(params[:course_id])
  end
  
  def get_tasks_edit_select
    @task_select = Task.get_select_item(params[:course_id], params[:id])
  end
  
  def get_has_reference_task_title
    @referenced_task_titles = Task.get_has_reference_task_title(params[:id])
  end
  
  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :start_date, :end_date, :description, :reference_task_id)
  end
end
