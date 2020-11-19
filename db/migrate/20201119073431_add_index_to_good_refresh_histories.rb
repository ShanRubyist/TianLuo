class AddIndexToGoodRefreshHistories < ActiveRecord::Migration[5.2]
  def change
    add_index :goods_refresh_histories, :pdd_web_spider_setting_id
  end
end
