class AddIndexToTables < ActiveRecord::Migration[5.2]
  def change
    add_index :coupons, :good_id
    add_index :dsrs, :shop_id
    add_index :goods, :shop_id
    add_index :goods_comments, :good_id
    add_index :goods_extras, :good_id
    add_index :goods_images, :good_id
    add_index :mall_services, :good_id
    add_index :pdd_web_spider_settings, :user_id
    add_index :probe_settings, :user_id
    add_index :rss_feeds, :rss_probe_history_id
    add_index :rss_probe_failure_histories, :probe_setting_id
    add_index :rss_probe_histories, :probe_setting_id
    add_index :shops, :platform_id
    add_index :shops, :pdd_web_spider_setting_id
    add_index :shops_extras, :shop_id
    add_index :skus, :good_id
    add_index :skus_extras, :sku_id
    add_index :user_rss_feed_ships, :user_id
    add_index :user_rss_feed_ships, :rss_feed_id
  end
end
