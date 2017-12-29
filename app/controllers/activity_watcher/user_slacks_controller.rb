class ActivityWatcher::UserSlacksController < ActivityWatcher::BaseController
  before_action :set_user_slack, only: [:destroy]
  before_action :get_course_select, only: [:index]

  def index
    @user_slacks = UserSlack.get_user_slacks_list(current_user.id).page(params[:page])
  end
  
  def destroy
    @user_slack.destroy
    respond_to do |format|
      format.html { redirect_to slack_index_url, notice: "Slackワークスペースの連携を解除しました"}
    end
  end
  
  def collaborate_course
    respond_to do |format|
      if UserSlack.collaborate_course(params[:course_id], params[:user_slack_id])
        if params[:user_slack_id]
          notice = "コースとの紐付きをしました。"
        else
          notice = "コースとの紐付きを解除しました。"
        end
        format.html { redirect_to slack_index_url, notice: notice}
      end
    end
  end
  
  private
  
  def get_course_select
    @course_select = Course.get_select_non_user_slacks(current_user.id)
  end
  
  def set_user_slack
    @user_slack = UserSlack.find_by(id: params[:id])
  end
end
