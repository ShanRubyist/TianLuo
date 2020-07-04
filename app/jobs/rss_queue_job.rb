class RssQueueJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # 从数据库获取 RSS 探针配置信息
    ProbeSetting.all.each do |s|
      RssWorkJob.perform_later(s)
    end
  end
end
