class ActivityWatcher::TaskTeamsController < ActivityWatcher::BaseController
  before_action :set_task_team, only: [:show, :edit, :update]
  before_action :get_team, only: [:show]

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task_team.update(task_team_params)
        format.html { redirect_to team_url(@task_team.team_id), notice: '情報を更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  private
  
  def get_team
    @team = @task_team.team
  end
  
  def set_task_team
    @task_team = TaskTeam.find_by(id: params[:id])
  end

  def task_team_params
    params.require(:task_team).permit(:repository_name, :service_url, :ci_url)
  end
end
