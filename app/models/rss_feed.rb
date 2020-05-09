class RssFeed < ApplicationRecord
  belongs_to :rss_probe_history

  default_scope -> { order('created_at desc') }
end
