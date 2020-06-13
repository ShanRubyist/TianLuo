class RssProbeHistory < ApplicationRecord
  belongs_to :probe_setting
  has_many :rss_feeds
end
