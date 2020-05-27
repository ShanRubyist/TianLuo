module RSSConcern
  extend ActiveSupport::Concern

  included do |base|
    def rss_list(page = 1, per = 20)
      RssFeed.joins(
          :rss_probe_history => {
              :probe_setting => :user
          }
      ).where(:users => {:id => current_user.id}).order_by_desc.page(page).per(per)
    end
  end

  module ClassMethods
  end
end