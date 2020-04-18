require 'spider'

class WebSpiderWorkJob < ApplicationJob
  queue_as :web_spider

  rescue_from(WebSpider::FetchException) do |exp|
    record_failure(exp)
  end

  rescue_from(PDDWebSpider::NeedLoginException) do |exp|
    record_failure(exp)
    retry_job wait: 60.minutes, queue: :web_spider
  end

  def record_failure(exp)
    # probe_setting = self.arguments.first
    #
    # RssProbeFailureHistory.store_fail_rss_to_db(
    #     probe_setting.id,
    #     exp.message,
    #     exp.backtrace.join('<br />')
    # )
  end

  def perform(setting)
    # 获取网页数据
    data = PDDWebSpider.new(setting.url).parse
    # 保存商品信息到数据库
    Good.store_goods_to_db(setting, data)
  end
end
