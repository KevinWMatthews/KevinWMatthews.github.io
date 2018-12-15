require 'octokit'
require 'json'

# The GitHub Pages API is in beta/preview:
# https://developer.github.com/v3/repos/pages/#get-information-about-a-pages-site
# For now, use the homepage that is entered on the repo page.

def get_repos(username)
    client = Octokit::Client.new
    client.auto_paginate = true
    client.repos username
end

# TODO: convert to one-line if statements
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
    true
end

def get_link(repo)
    {
        :name => repo.name,
        :url => repo.homepage,
        :description => repo.description,
    }
end

def write_links_to_file(links, filepath)
    File.open(filepath, "w") do |file|
        file.write(links.to_json)
    end
end

class TagPageGenerator < Generator
  safe true

  def generate(site)
      username = 'KevinWMatthews'
      filepath = "../_data/links.json"
      repos = get_repos username
      links = repos.select { |repo| has_webpage(repo) }.collect { |repo| get_link(repo) }
      #DEBUG
      links.each do |link|
          puts "name: #{link[:name]}, description: #{link[:description]}, url: #{link[:url]}"
      end
      write_links_to_file(links, filepath)
  end
end
