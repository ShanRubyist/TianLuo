require 'robot'

class RssWorkJob < ApplicationJob
  queue_as :rss_job

  rescue_from(Robot::RSSProbe::FetchException) do |exp|
    record_failure(exp)
  end

  rescue_from(Robot::RSSProbe::RetryTooManyTimeException) do |exp|
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

  def perform(setting)
    # 获取 RSS Feed
    rss_feeds = Robot::RSSProbe.new(setting.url).parse

    user_id = setting.user_id

    # 保持 RSS 信息到数据库
    RssFeed.store_rss_to_db(user_id, setting.id, rss_feeds)
  end
end
