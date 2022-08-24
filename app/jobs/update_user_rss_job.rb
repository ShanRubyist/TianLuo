class UpdateUserRssJob < ApplicationJob
  queue_as :update_job

  include ApplicationHelper

  # rescue_from(StandardError) do |exp|
  # end

  def perform(args)
    args[:page] ||= 1
    args[:per_page] ||= 100

    rss_feed_list = present('RssFeedPresenter',
                            user_id: args[:user_id],
                            rss: args[:rss],
                            page: args[:page],
                            per: args[:per])
                      .rss_feed

    rss_list = present('RssPresenter',
                       user_id: args[:user_id],
                       page: args[:page],
                       per: args[:per])
                 .rss

    rst = rss_feed_list.merge!({ type: 'tl_update_unread_count' }, { rss_list: rss_list })

    ActionCable.server.broadcast "tl_#{args[:user_id]}_channel", info: rst
  end
end
