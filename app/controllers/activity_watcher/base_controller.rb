class ActivityWatcher::BaseController < ApplicationController
  before_action :authenticate
  
  helper_method :current_user, :logged_in?, :current_universities, :get_source_path
  
  LIST_PAGINATE_TEAM_TASKS = 5
  
  def change_university
    session[:university_id] = params[:university_id]
    
    redirect_to activity_watcher_url
  end

  private

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end
  
  def current_universities
    return unless session[:user_id]
    @current_universities ||= current_user.universities.order('user_universities.id').pluck(:name, :id)
  end

  def logged_in?
    !!session[:user_id]
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: 'ログインしてください'
  end
  
  # 遷移元path取得用メソッド
  def get_source_path
    @path = Rails.application.routes.recognize_path(request.referrer)
  end
end