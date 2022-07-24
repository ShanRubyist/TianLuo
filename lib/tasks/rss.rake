require 'robot'
require 'pp'
require_relative '../../app/models/concerns/rss_savable'

module Anonymous
  include RssSavable
end

namespace :rss do
  desc 'get webpage'
  task 'get_raw_data', [:url] => [:environment] do |_, args|
    puts Robot::RSSProbe.new(args[:url]).fetch
  end

  desc 'get rss'
  task :get_rss, :url do |_, args|
    response = Robot::RSSProbe.new(args[:url]).fetch
    pp Anonymous.send :transform, response
  end

  desc 'get favicon'
  task :find_favicon_link, :url do |_, args|
    pp Anonymous.send :find_favicon_link, args[:url]
  end

end