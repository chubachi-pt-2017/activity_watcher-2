require "octokit"

class GithubManager

  attr_accessor :access_token

  def initialize(user_access_token)
    @access_token = user_access_token
  end

  # repository: "chubachi-pt-2017/e_sal"
  def get_contributors_for_the_repository(repository)
    client = Octokit::Client.new access_token: @access_token

    client.contributors_stats(repository)
    .sort{ |a,b| b[:total] <=> a[:total] }
    .map{ |member| p member[:author][:login] }
  end
end