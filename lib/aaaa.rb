require "octokit"

class Aaaa
  
  # def initialize()
  # end

  # def hello
  #   # puts "FooBar: hello world"
  #       puts "aaaaaaaaaaaaa"
  # end

  def hoge
    client = Octokit::Client.new access_token: "431e30709592b796228ac5292cb6ef97eb335af4"
    client.contributors_stats('chubachi-pt-2017/activity_watcher-2').sort{|a,b| b[:total] <=> a[:total]}.map {|member|
      p member[:author][:login]
    }
  end
end