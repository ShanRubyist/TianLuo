class CreateUserRssFeedShips < ActiveRecord::Migration[5.2]
  def change
    create_table :user_rss_feed_ships do |t|
      t.integer :user_id, comment: '用户ID'
      t.integer :rss_feed_id, comment: 'RSS Feed ID'
      t.boolean :unread, default: true, comment: '是否已读'

      t.timestamps
    end
  end
end
