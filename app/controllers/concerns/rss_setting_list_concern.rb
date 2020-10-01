require 'sidekiq/api'

module RSSSettingListConcern
  extend ActiveSupport::Concern

  included do |base|
    def running_rss_jobs_count
      Sidekiq::Queue.new('rss_job').size
    end

    def running_goods_jobs_count
      Sidekiq::Queue.new('web_spider').size
    end
  end

  module ClassMethods
  end
end
