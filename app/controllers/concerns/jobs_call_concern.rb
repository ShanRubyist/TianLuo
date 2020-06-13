module JobsCallConcern
  extend ActiveSupport::Concern

  included do |base|
    def call_rss_queue_job
      # 从数据库获取 RSS 探针配置信息
      ProbeSetting.all.each do |s|
        RssWorkJob.perform_later(s)
      end
    end

    def call_web_spider_work_job(setting)
      # 获取网页数据
      data = PDDWebSpider.new(setting.url).parse
      # 保存商品信息到数据库
      Good.store_goods_to_db(setting, data)
    end

    def call_web_spider_queue_job
      # 从数据库获取 Web Spider 配置信息
      PddWebSpiderSetting.all.each do |s|
        WebSpiderWorkJob.set(wait: (Random.rand(60)).minutes).perform_later(s)
      end
    end

    def call_rss_work_job(setting)
      # 获取 RSS Feed
      rss_feeds = RSSProbe.new(setting.url).parse

      user_id = setting.user_id

      # 保持 RSS 信息到数据库
      RssFeed.store_rss_to_db(user_id, setting.id, rss_feeds)
    end
  end

  module ClassMethods
  end
end
