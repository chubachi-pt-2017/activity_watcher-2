require "octokit"

class GithubManager

  # attr_accessor :access_token
  attr_accessor :client
  attr_accessor :repo

  def initialize(user_access_token, repo_name)
    # @access_token = user_access_token
    @client = Octokit::Client.new access_token: user_access_token
    @repo = repo_name
  end

  # repository: "chubachi-pt-2017/e_sal"
  def get_contributors_for_the_repository(repository)
    # client = Octokit::Client.new access_token: @access_token
    
    result = {}
    @client.contributors_stats(repository)
    .sort{ |a,b| b[:total] <=> a[:total] }
    .map{ |member| result[member[:author][:id]] = member[:author][:login] }

    result
  end

  # repo: "chubachi-pt-2017/activity_watcher-2"
  # days: 最小値は7。7は1週間前の週になる。14は2週間前の週になる
  def get_commits_between_weeks(repo, days)
    commit_numbers = {}
    commit_numbers if days < 7

    this_sunday = get_this_sunday

    # 第2引数は先週日曜、第3引数は土曜
    commits = @client.commits_between(repo, this_sunday - days, this_sunday - (days - 6))
    # commits = @client.commits(repo)
    # 同姓同名がいるかもしれない&github login IDを変更しているかもしれないので、emailをキーにしてコミット数をまとめる
    commits.each do |c|
      if c[:author][:id].present?
        if commit_numbers.has_key?(c[:author][:id])
          commit_numbers[c[:author][:id]] += 1
        else
          commit_numbers[c[:author][:id]] = 1
        end
      end
    end

    commit_numbers
  end
  
  def get_commits_this_week
    this_sunday = get_this_sunday
    commits = @client.commits_between(repo, this_sunday, Date.today)
    this_week = [0, 0, 0, 0, 0, 0, 0] #日曜[0]〜土曜[6]

    commits.each do |c|
      if c[:commit][:author][:date].present?
        this_week[c[:commit][:author][:date].in_time_zone('Tokyo').wday] += 1
      end
    end
    this_week.join(",")
  end

  # repository: "chubachi-pt-2017/activity_watcher-2"
  # days: 最小値は7。7は1週間前の週になる。14は2週間前の週になる
  def get_merged_pull_requests_between_weeks(repository, days)
    merged_pull_request = {}
    merged_pull_request if days < 7

    # state: "open" or "closed"    
    pr = client.pull_requests(repository, :state => "closed")

    this_sunday = get_this_sunday
    # github login IDが変更されているかもしれないので、UIDをキーにしてclosedのpull request数をまとめる
    pr.each do |pr|
      if pr[:user][:id].present? && ( pr[:merged_at].present? && 
                                      pr[:merged_at].between?(this_sunday - days, this_sunday - (days - 6)) )

        if merged_pull_request.has_key?(pr[:user][:id])
          merged_pull_request[pr[:user][:id]] += 1
        else
          merged_pull_request[pr[:user][:id]] = 1
        end
      end
    end

    merged_pull_request
  end

  # days: 最小値は7。7は1週間前の週になる。14は2週間前の週になる
  def get_pull_request_comments_between_weeks(repo, days)
    comment_numbers = {}
    comment_numbers if days < 7    

    this_sunday = get_this_sunday

    pr_numbers = client.pull_requests(repo, {"state" => "closed"})
                 .map{ |pr| { pr[:number] => pr[:user][:id] } if pr[:merged_at].present? &&
                                                                 pr[:merged_at].in_time_zone('Tokyo').between?(this_sunday - days, this_sunday - (days - 6)) }

    pr_numbers.compact.each do |number_hash|
      pr_comments = client.pull_request_comments(repo, number_hash.keys[0])

      pr_comments.each do |comment|
        # コメントした人がpull requestの作成者だったら
        next if comment[:user][:id] == number_hash.values[0]

        if comment_numbers.has_key?(comment[:user][:id])
          comment_numbers[comment[:user][:id]] += 1
        else
          comment_numbers[comment[:user][:id]] = 1
        end
      end

    end

    comment_numbers
  end

  def get_latest_commits(task_start_date)
    all_commits = @client.commits_since(@repo, task_start_date)
    result = Hash.new { |h,k| h[k] = {} }

    all_commits.each_with_index do |commit, i|
      break if i == 10
      result[commit[:sha]][:message] = commit[:commit][:message]
      result[commit[:sha]][:commit_url] = commit[:html_url]
      result[commit[:sha]][:committer] = commit[:commit][:author][:name]
      result[commit[:sha]][:date] = commit[:commit][:author][:date].in_time_zone("Tokyo")
    end

    result
  end

  private
    def get_this_sunday
      today = Date.today
      this_sunday = today - (today.wday)
    end

end