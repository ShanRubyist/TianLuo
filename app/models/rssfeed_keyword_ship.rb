class RssfeedKeywordShip < ApplicationRecord
  belongs_to :keyword
  belongs_to :rss_feed

  validates :keyword_id, presence: true
  validates :rss_feed_id, presence: true
end
