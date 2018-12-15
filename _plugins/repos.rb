# Custom plugins seem to be disabled on GitHub pages, likely for security reasons.
# Due to this I've stripped out the Jekyll generator.
# Run this script manually and commit the results.

require 'octokit'
require 'json'

class LinksGenerator
    attr_reader :username, :output_file_path
    def initialize(username, output_file_path)
        @username = username
        @output_file_path = output_file_path
    end

    def generate()
        repos = github_repos @username
        links = links_for_webpages(repos)
        links.each do |link|
            puts "name: #{link[:name]}, description: #{link[:description]}, url: #{link[:url]}"
        end
        write_links_to_file(links, @output_file_path)
    end

    def github_repos(username)
        # The GitHub Pages API is in beta/preview:
        # https://developer.github.com/v3/repos/pages/#get-information-about-a-pages-site
        # For now, use the homepage that is entered on the repo page.
        client = Octokit::Client.new
        client.auto_paginate = true
        client.repos username
    end

    def links_for_webpages(repos)
        repos.select { |repo| has_webpage(repo) }.collect { |repo| get_link(repo) }
    end

    def has_webpage(repo)
        return false if repo.fork?
        return false if not repo.homepage?
        return false if repo.homepage.strip.empty?
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
        text = links.to_json
        File.open(filepath, "w") do |file|
            file.write(text)
        end
    end
end

generator = LinksGenerator.new("KevinWMatthews", "_data/links.json")
generator.generate
