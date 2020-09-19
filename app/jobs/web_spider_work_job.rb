require 'robot'

class WebSpiderWorkJob < ApplicationJob
  queue_as :web_spider

  rescue_from(Robot::PDDWebSpider::FetchException) do |exp|
    record_failure(exp)
  end

  rescue_from(Robot::PDDWebSpider::NeedLoginException) do |exp|
    record_failure(exp)
    # retry_job wait: 60.minutes, queue: :web_spider
  end

  rescue_from(NoMethodError) do |exp|
    record_failure(exp)
  end

  def record_failure(exp)
    web_spider_setting = self.arguments.first

    WebSpiderFailureHistory.store_fail_spider_to_db(
        web_spider_setting.id,
        exp.message,
        exp.backtrace.join('<br />')
    )
  end

  def perform(setting)
    # 获取网页数据
    data = Robot::PDDWebSpider.new(setting.url,
                                   port: setting.port,
                                   proxy: setting.proxy,
                                   retry_limit: setting.retry_limit,
                                   log_path: setting.log_path,
                                   cookies: setting.cookies).parse

    # 保存商品信息到数据库
    Good.store_goods_to_db(setting, data)
  end
end
