class ActivityWatcher::TeamsController < ActivityWatcher::BaseController
  before_action :set_team, only: [:show, :destroy]
  before_action :set_team_with_participants, only: [:edit, :update]
  before_action :get_new_member_list, only: [:new, :create]
  before_action :get_edit_member_list, only: [:edit, :update]

  def show
  end

  def new
    @team = Team.new
    @team.task_teams.build
  end

  def edit
  end

  def create
    @team = Team.new(team_create_params)
    
    # current_userのidを参加者に追加
    if params[:team][:user_ids]
      @team.user_ids.push(current_user.id)
    else
      @team.user_ids = [current_user.id]
    end
    @team.task_teams.first.task_id = params[:task_id]
    

    respond_to do |format|
      if @team.save
        format.html { redirect_to task_url(params[:task_id]), notice: 'チームを作成しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_update_params)
        format.html { redirect_to @team, notice: 'チームを更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to _task_teams_url(params[:task_id]), notice: 'チームを削除しました' }
    end
  end

  private
  
  def get_new_member_list
    user_ids = Task.includes(:course).find_by(id: params[:task_id]).course.course_participants.pluck(:user_id)
    @participants = User.Student.where(id: user_ids).order(:login_name).pluck(:login_name, :id)
  end
  
  def get_edit_member_list
    task_id = Team.find_by(id: params[:id]).tasks.ids[0]
    user_ids = Task.includes(:course).find_by(id: task_id).course.course_participants.pluck(:user_id)
    @participants = User.Student.where(id: user_ids).order(:login_name).pluck(:login_name, :id)
  end
  
  def set_team
    @team = Team.find_by(id: params[:id])
  end
  
  def set_team_with_participants
    @team = Team.includes(:team_participants).find_by(id: params[:id])
  end
  
  def team_create_params
    params.require(:team).permit(:name, :description,:users, 
      task_teams_attributes: [:id, :repository_name, :service_url, :ci_url],
      user_ids: []
      )
  end

  def team_update_params
    params.require(:team).permit(:name, :description,
      team_participants_attributes: [:id, :user_id, :team_id, :_destroy]
      )
  end
end
