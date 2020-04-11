require 'probe'

class RssWorkJob < ApplicationJob
  queue_as :default

  rescue_from(RSSProbe::FetchException) do
    # do something here
  end

  def perform(*args)
    # 1、从数据库获取 RSS 探针配置信息
    ProbeSetting.all.each do |s|
      # 2、获取 RSS Feed
      rss_feeds = RSSProbe.new(s.url).parse
      # 3、保持 RSS 信息到数据库
      RssProbeHistory.store_rss_to_db(s.id, rss_feeds)
    end
  end
end
