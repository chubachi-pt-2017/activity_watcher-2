class ActivityWatcher::HomesController < ActivityWatcher::Base
  def index
    @teams = Team.all

    @results = []
    @teams.each do |team|
      github = github_info(team)
      @results.push(name: team.name,
                    source: team.source, service: team.service,
                    github: github)
    end
  end

  def github_info(team)
    repo = team.source.match(/.*\/(.*\/.*)/)[1]
    github = {}
    github[:contributors] = contributors(repo)
    github
  end

  def contributors(repo)
    client = Octokit::Client.new
    contributors = []
    client.contributors(repo).each do |contributor|
      name = find_name_by_login_from_member(contributor[:login])
      contributors.push(login: contributor[:login],
                        url: contributor[:html_url],
                        contributions: contributor[:contributions],
                        name: name)
    end
    contributors
  end

  def find_name_by_login_from_member(login)
    member = Member.find_by(login: login)
    member ? member.name : ''
  end
end
