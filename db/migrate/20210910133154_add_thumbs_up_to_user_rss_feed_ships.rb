class AddThumbsUpToUserRssFeedShips < ActiveRecord::Migration[5.2]
  def change
    add_column :user_rss_feed_ships, :thumbs_up, :boolean, default: false, comment: '是否点赞'
  end
end
