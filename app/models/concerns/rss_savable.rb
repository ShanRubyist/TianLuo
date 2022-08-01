# frozen_string_literal: true

require 'rss'
require 'rest-client'

module RssSavable
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def store_rss_to_db(probe_setting, rss_probe_history_id, job_id, rss_raw_data)
      rss = transform(rss_raw_data)
      title = rss[:title]
      description = rss[:description]
      last_build_date = rss[:last_build_date]
      link = rss[:link]
      items = rss[:items]

      # 更新 rss info 信息
      favicon_url = find_favicon_link(link) || default_favicon_location(link)
      RssInfo
          .find_or_create_by(probe_setting: probe_setting)
          .update!(
              title: title,
              description: description,
              link: link,
              icon: favicon_url)

      # 增量更新，同一 probe setting 已有的RSS Feed不会重复添加
      items.each do |item|
        rss_feed = RssFeed.create_with(
            title: item[:title],
            description: item[:description],
            author: item[:author],
            pub_date: item[:pub_date],
            enclosure: item[:enclosure],
            rss_probe_history_id: rss_probe_history_id
        ).find_or_create_by(link: item[:link], probe_setting: probe_setting)

        # 把RSS Feed内容分发到用户的内容队列中，默认为未读
        probe_setting.users.each do |user|
          UserRssFeedShip.find_or_create_by(user: user, rss_feed: rss_feed)
        end
      end

      # 更新历史信息
      RssProbeHistory
          .find_or_create_by(jid: job_id)
          .update({title: title, description: description})
    end

    private

    # feedbin
    def find_favicon_link(host)
      host = URI(host).host
      favicon_url = nil

      response = RestClient.get(host).body
      html = Nokogiri::HTML(response)
      favicon_links = html.search(xpath)

      if favicon_links.present?
        favicon_url = favicon_links.first.to_s
        favicon_url = URI.parse(favicon_url)
        favicon_url.scheme = "http"

        unless favicon_url.host
          favicon_url = URI::HTTP.build(scheme: "http", host: host)
          favicon_url = favicon_url.merge(favicon_links.last.to_s)
        end
      end

      favicon_url.to_s

      rescue
        nil
    end

    # feedbin
    def xpath
      icon_names = ["shortcut icon", "icon", "apple-touch-icon", "apple-touch-icon-precomposed"]
      icon_names = icon_names.map { |icon_name|
        "//link[not(@mask) and translate(@rel, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = '#{icon_name}']/@href"
      }
      icon_names.join(" | ")
    end

    # feedbin
    def default_favicon_location(host)
      URI::HTTP.build(host: URI(host).host, path: "/favicon.ico")
    end

    def transform(response)
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
            #atom_link: feed.atom_link.href,
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
              pub_date: item.published.content,
              # enclosure: item.enclosure&.url
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
            #atom_link: feed.channel.atom_link,
            last_build_date: feed.channel.lastBuildDate,
            items: []
        }

        feed.channel.items.each do |item|
          feed_hash[:items] << {
              title: item.title,
              description: item.content_encoded || item.description,
              link: item.link,
              author: item.author,
              pub_date: item.pubDate,
              enclosure: item.enclosure&.url
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
