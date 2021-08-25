class RssFeedTagShip < ApplicationRecord
  belongs_to :tag
  belongs_to :rss_feed
end
