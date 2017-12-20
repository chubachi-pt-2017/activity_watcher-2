class ActivityWatcher::UserSlacksController < ActivityWatcher::BaseController
  before_action :set_user_slack, only: [:destroy]

  def index
    @user_slacks = UserSlack.get_user_slacks_list(current_user.id).page(params[:page])
  end
  
  def destroy
    @user_slack.destroy
    respond_to do |format|
      format.html { redirect_to slack_index_url, notice: "Slackワークスペースの連携を解除しました"}
    end
  end
  
  private
  
  def set_user_slack
    @user_slack = UserSlack.find_by(id: params[:id])
  end
end
