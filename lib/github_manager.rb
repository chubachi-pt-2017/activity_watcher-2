require "octokit"

class GithubManager

  SEVEN_DAYS = 7
  FOURTEEN_DAYS = 14

  # attr_accessor :access_token
  attr_accessor :client
  attr_accessor :repo
  attr_accessor :this_sunday

  # @repo: "chubachi-pt-2017/activity_watcher-2"
  def initialize(user_access_token, repo_name)
    # @access_token = user_access_token
    @client = Octokit::Client.new access_token: user_access_token
    @repo = repo_name
    @this_sunday = get_this_sunday
  end

  # repository: "chubachi-pt-2017/e_sal"
  def get_contributors_for_the_repository
    # client = Octokit::Client.new access_token: @access_token
    
    result = {}
    @client.contributors_stats(@repo)
    .sort{ |a,b| b[:total] <=> a[:total] }
    .map{ |member| result[member[:author][:id]] = member[:author][:login] }

    result
  end

  # repo: "chubachi-pt-2017/activity_watcher-2"
  # days: 最小値は7。7は1週間前の週になる。14は2週間前の週になる
  def get_commits_yesterday
    commit_numbers = {}
    commits = @client.commits_on(@repo, Date.today - 1)

    # 同姓同名がいるかもしれない&github login IDを変更しているかもしれないので、
    # emailをキーにしてコミット数をまとめる
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
  
  def get_commits_since_specific_date(since_date)
    each_user_commits = Hash.new { |h,k| h[k] = {} }
    team_commits = @client.commits(@repo)

    team_commits.each_with_index do |c, i|
        #todo
      # break if c[:author][:date] < rails_cacheの最新date

      if each_user_commits.has_key?(c[:author][:id])
        each_user_commits[c[:author][:id]] += 1
      else
        each_user_commits[c[:author][:id]] = 1
      end
      
      if i == 0
        # todo
        # railsキャッシュに最新コミット日時を更新
        # raise c[:commit][:author][:date].inspect
      end
    end
    # todo
    # railsキャッシュに合計を更新
    each_user_commits
  end

  # days: 最小値は7。7は1週間前の週になる。14は2週間前の週になる
  def get_merged_pull_requests_yesterday
    merged_pull_request = {}
    # merged_pull_request if days < 7

    # state: "open" or "closed"    
    pr = client.pull_requests(@repo, :state => "closed")

    this_sunday = get_this_sunday
    # github login IDが変更されているかもしれないので、UIDをキーにしてclosedのpull request数をまとめる
    pr.each do |pr|
      if pr[:user][:id].present? && ( 
                                      pr[:merged_at].present? && 
                                      pr[:merged_at].between?(Date.today - 1, Date.today - 1)
                                    )

        if merged_pull_request.has_key?(pr[:user][:id])
          merged_pull_request[pr[:user][:id]] += 1
        else
          merged_pull_request[pr[:user][:id]] = 1
        end
      end
    end

    merged_pull_request
  end

  # 今週マージされたpull request
  def get_merged_pull_request_this_week
    this_week = [0, 0, 0, 0, 0, 0, 0] #日曜[0]〜土曜[6]
    prs = client.pull_requests(@repo, {"state" => "closed"})

    prs.each do |pr|
      jst_time = pr[:merged_at].in_time_zone('Tokyo')

      if pr[:merged_at].present? && jst_time.between?(@this_sunday - 21, Date.today)
        this_week[jst_time.wday] += 1
      end
    end

    this_week.join(",")
  end

  def get_latest_merged_pull_request_history
    closed_prs = client.pull_requests(@repo, {"state" => "closed"})
    result = Hash.new { |h,k| h[k] = {} }

    closed_prs.each do |pr|
      result[pr[:number]][:title] = pr[:title]
      result[pr[:number]][:url] = pr[:html_url]      
      result[pr[:number]][:creator] = pr[:user][:login]
      result[pr[:number]][:created_at] = pr[:created_at].in_time_zone("Tokyo")
    end

    result
  end

  def get_latest_open_pull_request_history
    open_prs = client.pull_requests(@repo)
    result = Hash.new { |h,k| h[k] = {} }

    open_prs.each do |pr|
      result[pr[:number]][:title] = pr[:title]
      result[pr[:number]][:url] = pr[:html_url]
      result[pr[:number]][:creator] = pr[:user][:login]
      result[pr[:number]][:created_at] = pr[:created_at].in_time_zone("Tokyo")
    end

    result
  end

  # days: 最小値は7。7は1週間前の週になる。14は2週間前の週になる
  def get_pull_request_comments_yesterday
    comment_numbers = {}
    # comment_numbers if days < 7
    # this_sunday = get_this_sunday

    pr_numbers = client.pull_requests(@repo, {"state" => "closed"})
                 .map{ |pr| { pr[:number] => pr[:user][:id] } if pr[:merged_at].present? &&
                                                                 pr[:merged_at].in_time_zone('Tokyo').between?(Date.today - 1, Date.today - 1) }

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

    all_commits.each do |commit|
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