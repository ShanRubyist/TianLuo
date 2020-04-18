class CreateGoods < ActiveRecord::Migration[5.2]
  def change
    create_table :goods do |t|
      t.string :name, comment: '商品名称'
      t.string :spu_id, comment: '商品编码'
      t.string :sales_num, comment: '商品销量'
      t.integer :goods_comments_count, commemnt: '本系统抓取的评论数量'
      t.string :comments_total_num, commemnt: '平台显示的评论总量'
      t.integer :shop_id, null: false

      t.timestamps
    end

    add_index :goods, :spu_id
  end
end