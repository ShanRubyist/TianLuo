class AddRssFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :rss_feeds do |t|
      t.string :title, comment: '文章标题'
      t.string :description, comment: '文章描述'
      t.string :author, comment: '作者'
      t.datetime :pub_date, comment: '发布时间'
      t.string :link, comment: '连接地址'

      t.integer :rss_probe_history_id, null: false

      t.timestamps
    end
  end
end
