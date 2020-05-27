class RssFeed < ApplicationRecord
  belongs_to :rss_probe_history

  # default_scope -> { order('created_at desc') }
  scope :order_by_desc, -> { order('created_at desc') }
end
