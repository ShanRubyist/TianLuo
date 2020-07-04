class WebSpiderQueueJob < ApplicationJob
  queue_as :web_spider

  def perform(*args)
    # 从数据库获取 Web Spider 配置信息
    PddWebSpiderSetting.all.each do |s|
      WebSpiderWorkJob.set(wait: (Random.rand(60)).minutes).perform_later(s)
    end
  end
end
