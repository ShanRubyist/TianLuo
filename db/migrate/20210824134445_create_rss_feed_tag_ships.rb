class CreateRssFeedTagShips < ActiveRecord::Migration[5.2]
  def change
    create_table :rss_feed_tag_ships do |t|
      t.integer :rss_feed_id
      t.integer :tag_id
      t.float :tf_idf

      t.timestamps
    end

    add_index :rss_feed_tag_ships, :rss_feed_id
    add_index :rss_feed_tag_ships, :tag_id
  end
end
