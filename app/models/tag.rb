class Tag < ApplicationRecord
  has_many :rss_feed_tag_ships
  has_many :rss_feeds, :through => :rss_feed_tag_ships
end
