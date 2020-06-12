class CreateShopsExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :shops_extras do |t|
      t.string :sales_num, comment: '销售量'
      t.string :goods_num, comment: '商品数量'
      t.integer :shop_id, null: false, comment: '关联店铺'

      t.timestamps
    end
  end
end
