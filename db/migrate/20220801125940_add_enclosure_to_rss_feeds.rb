class AddEnclosureToRssFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :rss_feeds, :enclosure, :string
  end
end
