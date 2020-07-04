require_relative 'web_spider'

module Robot
  class RSSProbe < WebSpider
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

    class RSSException < WebSpiderException
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