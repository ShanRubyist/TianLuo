module RssReadable
  extend ActiveSupport::Concern

  included do |base|
  end

  def rss_feeds_list(user_id = current_user.id, rss = nil, page = 1, per = 100)
    rst = RssFeed.includes(:user_rss_feed_ships)
              .includes(:probe_setting)
              .includes(:probe_setting => :rss_info)
              .where(:user_rss_feed_ships => {:user_id => user_id})

    rst = rst.where(:probe_settings => {:id => rss}) if rss

    rst.order('user_rss_feed_ships.unread desc')
        .order_by_desc
        .page(page)
        .per(per)
  end

  module ClassMethods
  end
end
