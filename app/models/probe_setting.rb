require_relative 'concerns/rss_list.rb'

class ProbeSetting < ApplicationRecord
  include RSSList

  has_many :user_rss_ships
  has_many :users, :through => :user_rss_ships

  has_one :rss_info

  has_many :rss_feeds

  has_many :rss_probe_histories
  has_many :rss_probe_failure_histories

  validates :url, presence: true#, uniqueness: true

  def save(*)
    res = super
    RssWorkJob.perform_later(self) if res
    res
  end
end
