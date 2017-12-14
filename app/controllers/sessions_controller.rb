class SessionsController < ApplicationController
  before_action :set_user, only: [:resend, :inform_email_unconfirmed]
  before_action :set_user_with_user_universities, only: [:register, :confirm]
  
  def callback
    auth = request.env['omniauth.auth']

    user = User.find_by(login_provider: auth['provider'], uid: auth['uid']) || User.create_with_omniauth(auth)
    
    # oauth_tokenをGithub認証のたびにupdate
    user.update_oauth_token(auth)
    
    session[:user_id] = user.id
    
    if user.registration_confirmed_flg == false
      redirect_to user_register_url
    elsif user.user_universities.email_unconfirmed.any?
      redirect_to users_email_unconfirmed_url
    else
      session[:university_id] = user.user_universities.pluck(:id, :university_id).sort_by(&:first).first.last
      redirect_to activity_watcher_url
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
  
  def register
    if @user.blank?
      redirect_to root_path
      return
    end
    @user.user_universities.build if @user.user_universities.blank?
  end
  
  def confirm
    params[:user][:confirmed] = false if params[:commit] == "戻る"
    @user.attributes = confirmation_params
    if @user.save(context: :user_registration)
      @user.update_attribute(:registration_confirmed_flg, true)
      
      @user_universities = @user.user_universities.email_unconfirmed
      
      if @user_universities.blank?
        session[:user_id] = @user.id
        session[:university_id] = @user.user_universities.pluck(:id, :university_id).sort_by(&:first).first.last
        redirect_to activity_watcher_url
        return
      end
      
      @user_universities.each do |user_university|
        user_university.update_email_confirmation_due_date
        NotificationMailer.send_confirm_to_user(user_university).deliver
      end

      redirect_to users_thanks_url
    else
      render action: 'register'
    end
  end
  
  
  # メールリンククリック後のaction
  def confirm_email
    user_university = UserUniversity.includes(:user).find_by(confirmation_token: params[:confirmation_token])
    
    respond_to do |format|
      if user_university.blank? || user_university.email_confirmation_due_date < Time.current
        format.html { render text: 'リクエストされたページは存在しません。', layout: 'application', status: '404' }
      else
        user_university.update_attribute(:email_confirmed_flg, true)
        
        user = user_university.user
        session[:user_id] = user.id
        
        if user.user_universities.email_unconfirmed.any?
          format.html { redirect_to users_email_unconfirmed_url }
        else
          session[:university_id] = user.user_universities.pluck(:id, :university_id).sort_by(&:first).first.last
          format.html { redirect_to activity_watcher_url }
        end
      end
    end
  end
  
  def inform_email_unconfirmed
    @user_universities = @user.user_universities.email_unconfirmed
  end
  
  def resend
    @user_universities = @user.user_universities.email_unconfirmed
    @user_universities.each do |user_university|
      user_university.update_email_confirmation_due_date
      NotificationMailer.send_confirm_to_user(user_university).deliver
    end
    
    redirect_to users_thanks_url
  end
  
  def thanks
  end
  
  private
  
  def set_user
    @user = User.find_by(id: session[:user_id])
  end
  
  def set_user_with_user_universities
    @user = User.includes(:user_universities).find_by(id: session[:user_id])
  end
  
  def confirmation_params
    params.require(:user).permit(
      :user_full_name,
      :slack_user,
      :authority,
      :teachers_password,
      :confirmed,
      user_universities_attributes: [:id, :email, :student_no, :user_id, :university_id, :_destroy]
    )
  end
end
