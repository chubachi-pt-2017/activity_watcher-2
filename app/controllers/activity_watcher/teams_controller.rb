class ActivityWatcher::TeamsController < ActivityWatcher::BaseController
  before_action :set_team, only: [:show, :edit]
  before_action :set_team_with_participants, only: [:update, :destroy]
  before_action :get_all_member_list, only: [:new, :create, :edit, :update]
  before_action :get_selected_member_list, only: [:new, :create, :edit, :update]
  before_action :get_course, only: [:show, :new, :edit, :create, :update]
  before_action :get_task, only: [:show, :new, :edit, :create, :update]

  def show
    if @team.blank?
      redirect_to list__course_tasks_url(params[:course_id])
      return
    end
    @task_teams = TaskTeam.get_tasks_lists_from_team(params[:id]).page(params[:page])
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
    if !params[:team][:user_ids]
      # メンバー未選択だったら
      @team.user_ids = [current_user.id]
    elsif params[:team][:user_ids].select{|n| n == current_user.id}.length < 1
      # current_userが含まれてなかったら
      @team.user_ids = params[:team][:user_ids].push(current_user.id)
    end

    @team.task_teams.first.task_id = params[:task_id]
    
    if @team.invalid?(:new_team)
      render :new
      return
    end
    
    # 当該課題をチーム構成の参照元にしている課題があれば追加で生成
    task_ids = Task.get_reference_task_ids(params[:task_id])
    @team.task_ids = task_ids if task_ids.length > 0


    @course = Course.find_by(id: params[:course_id])
    if @course.user_slack_id.present?
      slack = SlackManager.new(@course.user_slack.token)
      slack.create_channel(@team.name)
    end

    respond_to do |format|
      if @team.save
        format.html { redirect_to detail__course_task_url(params[:course_id], params[:task_id]), notice: 'チームを作成しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    params[:team][:user_ids] = params[:team][:user_ids].push(current_user.id) if params[:team][:user_ids].select{|user_id| user_id == current_user.id}.length == 0
    respond_to do |format|
      if @team.update(team_update_params)
        format.html { redirect_to _course_task_team_url(params[:course_id], params[:task_id], @team.id), notice: 'チームを更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to detail__course_task_url(params[:course_id], params[:task_id]), notice: 'チームを削除しました' }
    end
  end

  private
  
  def get_all_member_list
    @participants = Team.get_all_member_list(params[:course_id], params[:task_id])
  end
  
  def get_selected_member_list
    @selected_participants = Team.get_included_member_in_the_team(params[:course_id], params[:id])
  end
  
  def get_course
    @course = Course.find_by(id: params[:course_id])
  end
  
  def get_task
    @task = Task.find_by(id: params[:task_id])
  end
  
  def set_team
    @team = Team.find_by(id: params[:id])
  end
  
  def set_team_with_participants
    @team = Team.includes(team_participants: :user).find_by(id: params[:id])
  end
  
  def team_create_params
    params.require(:team).permit(:name, :description, :users, 
      task_teams_attributes: [:id, :repository_name, :service_url, :ci_url],
      user_ids: []
      )
  end

  def team_update_params
    params.require(:team).permit(:name, :description, :users, 
      user_ids: []
      )
  end
end
