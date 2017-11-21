class NotificationMailer < ApplicationMailer
  default from: '"ActivityWatcher" <noreply@activity-watcher.com>'

  def send_confirm_to_user(user_university)
    @user_university = user_university
    mail(
      subject: "利用者登録が完了しました。",
      to: @user_university.email
    ) do |format|
      format.html
    end
  end
end
