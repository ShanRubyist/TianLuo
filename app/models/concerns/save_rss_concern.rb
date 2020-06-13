# frozen_string_literal: true

module SaveRSSConcern
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def store_rss_to_db(user_id, probe_setting_id, rss)
      title = rss[:title]
      description = rss[:description]
      last_build_date = rss[:last_build_date]
      link = rss[:link]
      items = rss[:items]

      rss_probe_history = RssProbeHistory.create(probe_setting_id: probe_setting_id,
                                 title: title,
                                 description: description,
                                 last_build_date: last_build_date,
                                 link: link)

      items.each do |item|
        # 增量更新，已有的RSS Feed不会重复添加
        rss_feed = RssFeed.create_with(title: item[:title],
                                       description: item[:description],
                                       author: item[:author],
                                       pub_date: item[:pub_date],
                                       rss_probe_history_id: rss_probe_history.id)
                       .find_or_create_by(link: item[:link])

        # 把RSS Feed内容分发到用户的内容队列中，默认为未读
        # TODO: 应该要分发到有订阅此Rss的用户中
        UserRssFeedShip.find_or_create_by(user_id: user_id,
                                          rss_feed_id: rss_feed.id)
      end
    end
  end
end
