class CreateGoodsRefreshHistory < ActiveRecord::Migration[5.2]
  def change
    create_table :goods_refresh_histories do |t|
      t.datetime :last_update_date, comment: '最近更新时间'
      t.string :link, comment: '连接地址'
      t.string :jid, comment: 'sidekiq job id'
      t.string :status, comment: 'job 状态'
      t.string :detail, comment: '详细说明'

      t.integer :pdd_web_spider_setting_id , null: false

      t.timestamps
    end

    add_index :goods_refresh_histories, :jid
  end
end
