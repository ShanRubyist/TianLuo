module RSSConcern
  extend ActiveSupport::Concern

  included do |base|
    def rss_list(user_id = current_user.id, page = 1, per = 100)
      RssFeed
          .includes(:user_rss_feed_ships)
          .where(:user_rss_feed_ships => {:user_id => user_id})
          .order('user_rss_feed_ships.unread desc')
          .order_by_desc
          .page(page)
          .per(per)
    end
  end

  module ClassMethods
  end
end
