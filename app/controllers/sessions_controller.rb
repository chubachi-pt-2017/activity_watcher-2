class SessionsController < ApplicationController
  before_action :set_user, only: [:registration, :confirmation]
  
  def callback
    auth = request.env['omniauth.auth']

    user = User.find_by(provider: auth['provider'], uid: auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    
    if user.registration_confirmed_flg == false
      redirect_to user_registration_url
    elsif user.email_confirmation == false
      redirect_to users_email_unconfirmed_url
    else
      redirect_to activity_watcher_url
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
  
  def registration
    if @user.nil?
      redirect_to root_path
    end
  end
  
  def confirmation
    params[:user][:confirmed] = false if params[:commit] == "戻る"
    @user.attributes = confirmation_params
    if @user.save(context: :user_registration)
      @user.update_attribute(:registration_confirmed_flg, true)

      NotificationMailer.send_confirm_to_user(@user).deliver

      redirect_to users_thanks_url
    else
      render action: 'registration'
    end
  end
  
  
  # メールリンククリック後のaction
  def email_confirmation
    user = User.find_by(oauth_token: params[:oauth_token])
    
    respond_to do |format|
      if user.blank?
        format.html { render text: 'リクエストされたページは存在しません。', layout: 'application', status: '404' }
      else
        user.update_attribute(:email_confirmation, true)
        session[:user_id] = user.id
        format.html { redirect_to activity_watcher_url }
      end
    end
  end
  
  def email_unconfirmed
  end
  
  def thanks
  end
  
  private
  
  def set_user
    @user = User.find_by(id: session[:user_id])
  end
  
  def confirmation_params
    params.require(:user).permit(
      :email,
      :user_full_name,
      :university_id,
      :slack_user,
      :student_no,
      :authority,
      :teachers_password,
      :confirmed
    )
  end
end
