class RssFeed < ApplicationRecord
  include RssSavable
  include RssReadable

  belongs_to :probe_setting

  belongs_to :rss_probe_history

  has_many :user_rss_feed_ships
  has_many :users, :through => :user_rss_feed_ships

  has_many :rssfeed_keyword_ships
  has_many :keywords, :through => :rssfeed_keyword_ships

  has_many :rss_feed_tag_ships
  has_many :tags, :through => :rss_feed_tag_ships

  # default_scope -> { order('created_at desc') }
  scope :order_by_desc, -> { order('rss_feeds.created_at desc') }

  def self.favor(user_id)
    RssFeed.includes(:user_rss_feed_ships)
           .includes(:rss_feed_tag_ships)
           .includes(:tags)
           .includes(:probe_setting)
           .includes(:probe_setting => :rss_info)
           .where(:user_rss_feed_ships => {:user_id => user_id, :thumbs_up => true})
           .order('user_rss_feed_ships.created_at desc')
           .limit(100)
  end

  def self.recommend_feeds(user_id, max_limit = 10)
    rst = UserRssFeedShip.find_by_sql(<<-SQL
      select rss_feed_tag_ships.tag_id, count(*) as n
      from user_rss_feed_ships
      inner join rss_feed_tag_ships
      on rss_feed_tag_ships.rss_feed_id = user_rss_feed_ships.rss_feed_id
     where user_rss_feed_ships.user_id = #{user_id} and user_rss_feed_ships.thumbs_up is true
      group by rss_feed_tag_ships.tag_id
      order by count(*) desc
      limit #{max_limit}
    SQL
    )
    return [rst,
    RssFeed.includes(:user_rss_feed_ships)
        .includes(:rss_feed_tag_ships)
        .includes(:tags)
        .includes(:probe_setting)
        .includes(:probe_setting => :rss_info)
        .where(:user_rss_feed_ships => {:user_id => user_id})
        .where(:rss_feed_tag_ships => {tag_id: rst.map(&:tag_id)})
        .order('rss_feed_tag_ships.tf_idf desc, user_rss_feed_ships.unread desc')
        .limit(100)
    ]
  end
end