class UserRssFeedShip < ApplicationRecord
  belongs_to :user
  belongs_to :rss_feed

  validates :user_id, presence: true
  validates :rss_feed_id, presence: true

  after_save { UpdateUserUnreadCountJob.perform_later(user_id: self.user_id) }
end
