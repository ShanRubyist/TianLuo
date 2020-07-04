require_relative 'web_spider'

module Robot
  class PDDWebSpider < WebSpider
    attr_accessor :platform

    def initialize(url, options = {})
      super(url, options)
      @platform = :PDD
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