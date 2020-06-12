class CreateGoodsExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :goods_extras do |t|
      t.string :name, comment: '商品名称'
      t.string :sales_num, comment: '商品销量'
      t.integer :goods_comments_count, commemnt: '本系统抓取的评论数量'
      t.string :comments_total_num, commemnt: '平台显示的评论总量'
      t.integer :good_id, null: false, comment: '关联商品ID'

      t.timestamps
    end
  end
end
