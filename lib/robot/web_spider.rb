require 'rest-client'
require 'logger'

module Robot
  class WebSpider
    attr_accessor :url, :headers, :proxy, :retry_limit,
                  :logger, :need_cache, :cache

    def initialize(url, options = {})
      @url = url
      @config = options

      @headers = config[:headers]
      @proxy = config[:proxy]
      @retry_limit = config[:retry_limit]
      @need_cache = config[:need_cache]
      @cache = config[:cache]
      @logger = Logger.new("#{Rails.root}/log/" + config[:log_path])
    end

    # 主入口
    # 1. 获取网页数据
    # 2. 处理数据
    # 3. 转换成系统想要的格式
    def parse
      logger.info("[+] Begin to parse #{self.class}: #{url}")
      response = fetch
      data = handle(response)
      logger.info("[+] End to parse #{self.class}: #{url}")

      data
    end

    # 获取网页源数据
    def fetch
      if need_cache && cache.fetch(url)
        cache.fetch(url)
      else
        retry_count = 0

        begin
          RestClient.proxy = config[:proxy] if config[:proxy]
          response = RestClient.get(url, headers).body
          cache.write(url, response, expires_in: 60.minutes) if need_cache
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
          logger.info("[+] Retry #{retry_count} times")

          retry_count += 1
          retry if retry_count <= retry_limit

          raise RetryTooManyTimeException
        end
        response
      end
    end

    # 处理网页源数据
    def handle(response)
      # raise "handle 是个抽象方法，需要在子类中实现"
      response
    end

    private

    def default_config
      {
          headers: {
              user_agent: 'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Mobile Safari/537.36',
              cookie: 'api_uid=CiHA5V7iPlODuABJ8t1zAg==; _nano_fp=XpdbXpCJnpXbn5TYXT_ecXxCswGPDgEcSFJPQB6h; PDDAccessToken=3M3NYVKDXFK6FRD3WJ6GGRZ577A5V537OBVIHVRWJ6NXHOKB7NFQ113d496; pdd_user_id=7201829222356; pdd_user_uin=W7U3BUPAEICPD2OZCJULVPRD2I_GEXDA; quick_entrance_click_record=20200611%2C253; ua=Mozilla%2F5.0%20(X11%3B%20Linux%20x86_64)%20AppleWebKit%2F537.36%20(KHTML%2C%20like%20Gecko)%20Chrome%2F70.0.3538.110%20Safari%2F537.36; webp=1'
          },
          retry_limit: 3,
          log_path: "#{self.class}.log",
          need_cache: true,
          cache: Rails.cache
      }
    end

    def config
      default_config.merge(@config)
    end

    class WebSpiderException < RuntimeError
    end

    class NotFoundException < WebSpiderException
    end

    class FetchException < WebSpiderException
    end

    class ParseException < WebSpiderException
    end

    class RetryTooManyTimeExcepiton < WebSpiderException
    end
  end
end