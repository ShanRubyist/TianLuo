class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.integer :vendor_id, comment: '平台店铺ID'
      t.string :shop_name, comment: '店铺名称'
      t.string :shop_url, comment: '店铺链接'
      t.string :sales_num, comment: '销售量'
      t.string :goods_num, comment: '商品数量'
      t.integer :platform_id, null: false, comment: '关联电商平台'
      t.integer :pdd_web_spider_setting_id, null: false, comment: '关联设置'

      t.timestamps
    end

    add_index :shops, :id
    add_index :shops, :vendor_id
  end
end
