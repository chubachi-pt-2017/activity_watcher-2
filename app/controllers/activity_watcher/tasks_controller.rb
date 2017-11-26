class ActivityWatcher::TasksController < ActivityWatcher::Base
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    @course = Course.find_by(id: params[:course_id])
    @tasks = @course.tasks.order(id: :asc)
  end

  # GET /tasks/1
  def show
    if @task.blank?
      respond_to do |format|
        format.html {render text: "リクエストされたURLは存在しません", layout: "activity_watcher/base", status: "404"}
      end
    end
    return
  end

  # GET /tasks/new
  def new
    @task = Task.new()
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.course_id = params[:course_id]

    respond_to do |format|
      if @task.save
        format.html { redirect_to _course_task_path(@task.course_id, @task.id), notice: '課題の作成が完了しました' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /tasks/1
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to _course_task_path(@task.course_id, @task.id), notice: '課題の修正が完了しました' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to _course_tasks_url, notice: '課題の削除が完了しました' }
    end
  end

  private

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :start_date, :end_date, :description, :slack_domain)
  end
end
