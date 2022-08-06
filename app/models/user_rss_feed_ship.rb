class UserRssFeedShip < ApplicationRecord
  belongs_to :user
  belongs_to :rss_feed

  validates :user_id, presence: true
  validates :rss_feed_id, presence: true

  after_commit do
    UpdateUserUnreadCountJob.perform_now(user_id: self.user_id)
    UpdateUnreadStatusJob.perform_now(user_id: self.user_id, rss: RssFeed.find_by_id(self.rss_feed_id).probe_setting_id)
  end
end
