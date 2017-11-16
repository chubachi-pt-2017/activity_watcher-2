class NotificationMailer < ApplicationMailer
  default from: 'noreply@activity-watcher.com'

  def send_confirm_to_user(user)
    @user = user
    mail(
      subject: "利用者登録が完了しました。",
      to: @user.email
    ) do |format|
      format.html
    end
  end
end
