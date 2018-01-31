class ActivityWatcher::TaskTeamsController < ActivityWatcher::BaseController
  before_action :set_task_team, only: [:edit, :update]
  before_action :get_course, only: [:edit, :update]
  before_action :get_task, only: [:edit, :update]
  before_action :get_team, only: [:edit, :update]

  def edit
  end

  def update
    respond_to do |format|
      if @task_team.update(task_team_params)
        format.html { redirect_to _course_task_team_url(params[:course_id], params[:task_id], @task_team.team_id), notice: '情報を更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  private
  
  def get_course
    @course = Course.find_by(id: params[:course_id])
  end
  
  def get_task
    @task = Task.find_by(id: params[:task_id])
  end
  
  def get_team
    @team = Team.find_by(id: params[:team_id])
  end
  
  def set_task_team
    @task_team = TaskTeam.find_by(id: params[:id])
  end

  def task_team_params
    params.require(:task_team).permit(:repository_name, :service_url, :ci_url)
  end
end
