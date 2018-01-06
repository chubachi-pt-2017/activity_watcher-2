class GithubController < ApplicationController
  def test
    github = GithubManager.new("431e30709592b796228ac5292cb6ef97eb335af4")
    # contributors
    # raise github.get_contributors_for_the_repository("chubachi-pt-2017/activity_watcher-2").inspect

    # 先週のコミット数取得
    # raise github.get_commits_last_week("chubachi-pt-2017/activity_watcher-2").inspect
    
    raise github.get_merged_pull_requests_last_week("chubachi-pt-2017/activity_watcher-2").inspect
  end
end