require "slack"

class SlackManager

  def initialize(workspace_access_token)
    @token = workspace_access_token
  end
  
  # ワークスペース招待メール送信(gemでサポートされていないmethodを使うためhttpartyを使用しURL直打ち)
  def send_invite_email(email)
    json = HTTParty.get("#{Slack.endpoint}/users.admin.invite?token=#{@token}&email=#{email}&resend=true")
    json['ok'] == true ? true : json['error']
  end
  
  # チャンネル作成
  def create_channel(channel_name)
    client = Slack::Client.new token: @token
    json = client.channels_create(name: channel_name)
    json['ok'] == true ? true : json['error']
  end
  
end