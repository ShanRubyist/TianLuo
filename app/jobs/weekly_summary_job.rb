class WeeklySummaryJob < ApplicationJob
  queue_as :default

  def perform(*args)
    WeeklySummaryMailer#.with(users: @users, rss_feeds: @rss_feeds, rss_sources: @rss_sources)
        .notify
        .deliver_later!
  end
end
