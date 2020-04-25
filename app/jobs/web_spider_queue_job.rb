class WebSpiderQueueJob < ApplicationJob
  queue_as :web_spider

  include JobsCallConcern

  def perform(*args)
    call_web_spider_queue_job
  end
end
