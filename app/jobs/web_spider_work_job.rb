require 'robot'

class WebSpiderWorkJob < ApplicationJob
  queue_as :web_spider

  include JobsCallConcern

  rescue_from(Robot::PDDWebSpider::FetchException) do |exp|
    record_failure(exp)
  end

  rescue_from(Robot::PDDWebSpider::NeedLoginException) do |exp|
    record_failure(exp)
    retry_job wait: 60.minutes, queue: :web_spider
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
    call_web_spider_work_job(setting)
  end
end
