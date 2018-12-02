require 'octokit'

# Instead, set and test environment variables, like below
client = Octokit::Client.new
client.auto_paginate = true

repos = client.repos 'KevinWMatthews'

# The GitHub Pages API is in beta/preview:
# https://developer.github.com/v3/repos/pages/#get-information-about-a-pages-site
# For now, use the homepage that is entered on the repo page.

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
        :description => repo.description,
    }
end

links = repos.select { |repo| has_webpage(repo) }.collect { |repo| get_link(repo) }

links.each do |link|
    puts "name: #{link[:name]}, description: #{link[:description]}, url: #{link[:url]}"
end

require 'json'
File.open("_data/links.json", "w") do |file|
    file.write(links.to_json)
end
