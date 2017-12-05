class ActivityWatcher::TeamsController < ActivityWatcher::BaseController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :get_team_member_list, only: [:new, :create]

  def show
  end

  def new
    @team = Team.new
    @team.team_participants.build
    @team.task_teams.build
  end

  def edit
  end

  def create
    @team = Team.new(team_create_params)
    @team.task_teams.first.task_id = params[:task_id]

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'チームを作成しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'チームを更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'チームを削除しました' }
    end
  end

  private
  
  def get_team_member_list
    @participants = User.Student.pluck(:login_name, :id).sort {|a, b| a[0] <=> b[0]}
  end
  
  def set_team
    @team = Team.find(params[:id])
  end

  def team_create_params
    params.require(:team).permit(:name, :description,:users, 
      task_teams_attributes: [:id, :repository_name, :service_url, :ci_url],
      user_ids: []
      )
  end
end
