require 'rss'
require 'rest-client'
require 'logger'

class RSSProbe
  attr_accessor :url, :headers, :proxy, :retry_limit, :logger

  def initialize(url, options = {})
    @url = url
    @config = options

    @headers = config[:headers]
    @proxy = config[:proxy]
    @retry_limit = config[:retry_limit]
    @logger = Logger.new("#{Rails.root}/log/" + config[:log_path])
  end

  def parse
    logger.info("[+] Begin to parse rss : #{url}")
    rss_feeds = fetch_n_handle
    logger.info("[+] End to parse rss : #{url}")
    rss_feeds
  end

  def fetch_n_handle
    retry_count = 0

    begin
      RestClient.proxy = config[:proxy] if config[:proxy]
      response = RestClient.get(url, headers).body
    rescue SocketError => e
      # 无法连接： 域名错误、端口错误
      logger.error(e)
      raise FetchException
    rescue Errno::ECONNREFUSED => e
      # 连接被拒绝
      logger.error(e)
      raise FetchException
    rescue RestClient::NotFound => e
      # 无法找到页面
      logger.error(e)
      raise FetchException
    rescue => e
      logger.error(e)

      retry_count += 1
      if retry_count <= retry_limit
        logger.info("[+] Retry #{retry_count} times")
	retry
      end

      raise RetryTooManyTimeException
    end

    begin
      feed = RSS::Parser.parse(response)
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

  private

  def default_config
    {
        headers: {
            user_agent: 'Mozilla\u002F5.0 (Windows NT 6.1; Win64; x64) AppleWebKit\u002F537.36 (KHTML, like Gecko) Chrome\u002F72.0.3626.121 Safari\u002F537.36'
        },
        proxy: nil,
        retry_limit: 3,
        log_path: "rss_probe.log"
    }
  end

  def config
    default_config.merge(@config)
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
end
