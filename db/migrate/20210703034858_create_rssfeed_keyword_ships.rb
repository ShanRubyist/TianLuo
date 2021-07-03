class CreateRssfeedKeywordShips < ActiveRecord::Migration[5.2]
  def change
    create_table :rssfeed_keyword_ships do |t|
      t.integer :rss_feed_id, null: false
      t.integer :keyword_id, null: false
      t.json :position, comment: '内容中关键词的位置'

      t.timestamps
    end

    add_index :rssfeed_keyword_ships, :rss_feed_id
    add_index :rssfeed_keyword_ships, :keyword_id
  end
end
