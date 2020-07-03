require_relative 'web_spider'
require 'json'

module Robot
  class PDDWebSpider < WebSpider
    attr_accessor :platform

    def initialize(url, options = {})
      super(url, options)
      @platform = :PDD
    end

    # 处理网页源数据
    def handle(response)
      begin
        raw_data = response.scan(/<script>.*window.rawData.*?({.*?);\s*<\/script>/m).join('')
        json_data = JSON.load(raw_data)
        raise NeedLoginException if json_data["store"]["initDataObj"]["needLogin"]
      rescue JSON::ParserError => e
        logger.error(e)
        raise ParseException
      rescue => e
        logger.error(e)
        raise e
      end
      json_data
    end

    private

    # def default_config
    #   config = super
    #   config['headers'].merge!({
    #                       cookies: ''
    #                   })
    # end

    class PDDWebSpiderException < WebSpiderException
    end

    class NeedLoginException < PDDWebSpiderException
    end
  end
end