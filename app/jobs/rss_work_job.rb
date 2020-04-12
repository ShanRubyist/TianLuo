require 'probe'

class RssWorkJob < ApplicationJob
  queue_as :rss_job

  rescue_from(RSSProbe::FetchException) do |exp|
    record_failure(exp)
  end

  rescue_from(RSSProbe::RetryTooManyTimeException) do |exp|
    record_failure(exp)
  end

  rescue_from(StandardError) do |exp|
    # StandardError 会捕获包括 RuntimeError 的异常
    record_failure(exp)
  end

  def record_failure(exp)
    probe_setting = self.arguments.first

    RssProbeFailureHistory.store_fail_rss_to_db(
        probe_setting.id,
        exp.message,
        exp.backtrace.join('<br />')
    )
  end

  def perform(probe_setting)
    # 获取 RSS Feed
    rss_feeds = RSSProbe.new(probe_setting.url).parse
    # 保持 RSS 信息到数据库
    RssProbeHistory.store_rss_to_db(probe_setting.id, rss_feeds)
  end
end
