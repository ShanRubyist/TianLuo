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
    fetch_n_handle
    logger.info("[+] End to parse rss : #{url}")
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
    rescue Exception::Errno::ECONNREFUSED => e
      # 连接被拒绝
      logger.error(e)
      raise FetchException
    rescue Exception::RestClient::NotFound => e
      # 无法找到页面
      logger.error(e)
      raise FetchException
    rescue => e
      logger.error(e)
      logger.info("[+] Retry #{retry_count} times")

      retry_count += 1
      retry if retry_count <= retry_limit

      raise RetryTooManyTimeException
    end

    begin
      feed = RSS::Parser.parse(response)
      puts "Title: #{feed.channel.title}"
      feed.items.each do |item|
        puts "Item: #{item.title}"
      end
    rescue RSS::NotWellFormedError => e
      logger.error(e)
      raise ParseException
    end
  end

  private

  def default_config
    {
        headers: {},
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

  class RetryTooManyTimeExcepiton < RSSException
  end
end