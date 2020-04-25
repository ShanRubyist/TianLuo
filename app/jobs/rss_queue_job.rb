class RssQueueJob < ApplicationJob
  queue_as :default

  include JobsCallConcern

  def perform(*args)
    call_rss_queue_job
  end
end
