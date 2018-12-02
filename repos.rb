require 'octokit'

# Instead, set and test environment variables, like below
client = Octokit::Client.new
client.auto_paginate = true

class Link
    attr_reader :name, :url

    def initialize(name, url)
        @name = name
        @url = url
    end
end

repos = client.repos 'KevinWMatthews'

# The GitHub Pages API is in beta/preview:
# https://developer.github.com/v3/repos/pages/#get-information-about-a-pages-site
# For now, use the homepage that is entered on the repo page.


# First method:
# pages = repos.select { |result| result.has_pages? and not result.fork? }
# links = pages.collect { |result| Link.new(result.name, result.homepage) }

# Second method:
# links = repos.map do |result|
    # if result.has_pages? and not result.fork?
        # Link.new(result.name, result.homepage)
    # end
# end
# links.compact!

def has_webpage(repo)
    if repo.fork?
        return false
    end
    if not repo.homepage?
        return false
    end
    if repo.homepage.strip.empty?
        return false
    end
    return true
end

def get_link(repo)
    {
        :name => repo.name,
        :url => repo.homepage,
    }
end

links = repos.select { |repo| has_webpage(repo) }.collect { |repo| get_link(repo) }

# links = repos.map do |result|
#     if has_webpage(result)
#         get_link(result)
#     end
# end
# links.compact!

links.each do |link|
    puts "name: #{link[:name]}, url: #{link[:url]}"
end

require 'json'
puts links.to_json

File.open("_data/links.json", "w") do |file|
    file.write(links.to_json)
end
