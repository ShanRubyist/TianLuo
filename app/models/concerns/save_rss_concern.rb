# frozen_string_literal: true

require 'rss'

module SaveRSSConcern
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def store_rss_to_db(user_id, rss_probe_history_id, job_id, rss_raw_data)
      rss = handle(rss_raw_data)
      title = rss[:title]
      description = rss[:description]
      last_build_date = rss[:last_build_date]
      link = rss[:link]
      items = rss[:items]

      # rss_probe_history = RssProbeHistory.create(probe_setting_id: probe_setting_id,
      #                            title: title,
      #                            description: description,
      #                            last_build_date: last_build_date,
      #                            link: link)

      RssProbeHistory
          .find_or_create_by(jid: job_id)
          .update({ title: title, description: description })

      items.each do |item|
        # 增量更新，已有的RSS Feed不会重复添加
        rss_feed = RssFeed.create_with(title: item[:title],
                                       description: item[:description],
                                       author: item[:author],
                                       pub_date: item[:pub_date],
                                       rss_probe_history_id: rss_probe_history_id)
                       .find_or_create_by(link: item[:link])

        # 把RSS Feed内容分发到用户的内容队列中，默认为未读
        # TODO: 应该要分发到有订阅此Rss的用户中
        UserRssFeedShip.find_or_create_by(user_id: user_id,
                                          rss_feed_id: rss_feed.id)
      end
    end

    private
    def handle(response)
      feed = RSS::Parser.parse(response)
      if feed.class == RSS::Atom::Feed
        parse_atom(feed)
      elsif feed.class == RSS::Rss
        parse_rss(feed)
      else
        raise Robot::RSSProbe::UnknownRssFormatException
      end
    end

    def parse_atom(feed)
      begin
        feed_hash = {
            title: feed.title.content,
            description: feed.subtitle.content,
            link: feed.link.href,
            last_build_date: feed.updated.content,
            items: []
        }
        logger.error feed.entries.count
        feed.entries.each do |item|
          feed_hash[:items] << {
              title: item.title.content,
              description: item.content.content,
              link: item.link.href,
              author: item.author.name.content,
              pub_date: item.published.content
          }
        end
        feed_hash
      rescue RSS::NotWellFormedError => e
        logger.error(e)
        raise Robot::WebSpider::ParseException
      end
    end

    def parse_rss(feed)
      begin
        feed_hash = {
            title: feed.channel.title,
            description: feed.channel.description,
            link: feed.channel.link,
            last_build_date: feed.channel.lastBuildDate,
            items: []
        }

        feed.channel.items.each do |item|
          feed_hash[:items] << {
              title: item.title,
              description: item.description,
              link: item.link,
              author: item.author,
              pub_date: item.pubDate
          }
        end
        feed_hash
      rescue RSS::NotWellFormedError => e
        logger.error(e)
        raise Robot::WebSpider::ParseException
      end
    end

  end
end
