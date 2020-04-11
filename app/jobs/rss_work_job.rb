require 'probe'

class RssWorkJob < ApplicationJob
  queue_as :rss_job

  rescue_from(RSSProbe::FetchException) do
    # do something here
  end

  def perform(probe_setting)
    # 获取 RSS Feed
    rss_feeds = RSSProbe.new(probe_setting.url).parse
    # 保持 RSS 信息到数据库
    RssProbeHistory.store_rss_to_db(probe_setting.id, rss_feeds)
  end
end
