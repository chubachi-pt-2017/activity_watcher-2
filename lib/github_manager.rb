require "octokit"
#require "open-uri"

class GithubManager

  # attr_accessor :access_token
  attr_accessor :client

  def initialize(user_access_token)
    # @access_token = user_access_token
    @client = Octokit::Client.new access_token: user_access_token
  end

  # repository: "chubachi-pt-2017/e_sal"
  def get_contributors_for_the_repository(repository)
    # client = Octokit::Client.new access_token: @access_token

    @client.contributors_stats(repository)
    .sort{ |a,b| b[:total] <=> a[:total] }
    .map{ |member| member[:author][:login] }
  end
  
  # repo: "chubachi-pt-2017/activity_watcher-2"
  def get_commits_last_week(repo)
    this_sunday = get_this_sunday

    # 第2引数は先週日曜、第3引数は土曜
    commits = @client.commits_between(repo, this_sunday - 7, this_sunday - 1)
    
    # 同姓同名がいるかもしれない&github login IDを変更しているかもしれないので、emailをキーにしてコミット数をまとめる
    result = {}
    commits.each do |c|
      if c[:commit][:author][:email].present?
        if result.has_key?(c[:commit][:author][:email])
          result[c[:commit][:author][:email]] += 1
        else
          result[c[:commit][:author][:email]] = 1
        end
      end
    end

    result
  end

  # repository: "chubachi-pt-2017/activity_watcher-2"
  # state: "open" or "closed"
  def get_merged_pull_requests_last_week(repository)
    client = Octokit::Client.new access_token: @access_token
    
    pr = client.pull_requests(repository, :state => "closed")
# raise pr[:closed_at].inspect
this_sunday = get_this_sunday
    # github login IDが変更されているかもしれないので、
    # UIDをキーにしてclosedのpull request数をまとめる
    result = {}
    pr.each do |pr|
      if pr[:user][:id].present? && (pr[:merged_at].present? && pr[:merged_at].between?(this_sunday - 7, this_sunday - 1) )
        if result.has_key?(pr[:user][:id])
          result[pr[:user][:id]] += 1
        else
          result[pr[:user][:id]] = 1
        end
      end
    end

    result
  end
  
  def get_this_sunday
    today = Date.today
    this_sunday = today - (today.wday)  
  end
end
