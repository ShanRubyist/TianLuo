class RssFeed < ApplicationRecord
  belongs_to :rss_probe_history

  has_many :user_rss_feed_ship
  has_many :user, :through => :user_rss_feed_ship

  # default_scope -> { order('created_at desc') }
  scope :order_by_desc, -> { order('created_at desc') }
end
