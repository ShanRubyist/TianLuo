module RssReadable
  extend ActiveSupport::Concern

  included do |base|
  end

  def rss_list(user_id = current_user.id, page = 1, per = 100, rss = params[:rss])
    # FIXME: 需要展示已读未读状态、rss源标题
    rst = RssFeed
              .includes(:user_rss_feed_ships)
              .includes(:rss_probe_history)
              .includes(:rss_probe_history => :probe_setting)
              .where(:user_rss_feed_ships => {:user_id => user_id})
    if rss
      rst = rst.where(:rss_probe_histories => {:probe_settings => {:id => rss}})
    end

    rst.order('user_rss_feed_ships.unread desc')
        .order_by_desc
        .page(page)
        .per(per)
  end

  module ClassMethods
  end
end
