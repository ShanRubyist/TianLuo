require_relative 'web_spider'
require 'rss'

module Robot
  class RSSProbe < WebSpider
    def handle(response)
      feed = RSS::Parser.parse(response)
      if feed.class == RSS::Atom::Feed
        parse_atom(feed)
      elsif feed.class == RSS::Rss
        parse_rss(feed)
      else
        raise UnknownRssFormatException
      end
    end

    private

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
        raise ParseException
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
        raise ParseException
      end
    end

    def default_config
      {
          headers: {
              user_agent: 'Mozilla\u002F5.0 (Windows NT 6.1; Win64; x64) AppleWebKit\u002F537.36 (KHTML, like Gecko) Chrome\u002F72.0.3626.121 Safari\u002F537.36'
          },
          proxy: nil,
          retry_limit: 3,
          need_cache: false,
          log_path: "#{self.class}.log"
      }
    end

    class RSSException < RuntimeError
    end

    class NotFoundException < RSSException
    end

    class FetchException < RSSException
    end

    class ParseException < RSSException
    end

    class RetryTooManyTimeException < RSSException
    end

    class UnknownRssFormatException < RSSException
    end
  end
end