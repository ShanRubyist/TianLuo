module RSSConcern
  extend ActiveSupport::Concern

  included do |base|
    def rss_list(page=1, per=20)
      RssFeed.includes(:rss_probe_history).page(page).per(per)
    end
  end

  module ClassMethods
  end
end