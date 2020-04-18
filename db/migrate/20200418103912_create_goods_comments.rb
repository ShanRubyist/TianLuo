class CreateGoodsComments < ActiveRecord::Migration[5.2]
  def change
    create_table :goods_comments do |t|
      t.string :customer_name, comment: '买家昵称'
      t.string :comment, comment: '评论内容'
      t.datetime :time, comment: '评论时间'
      t.integer :good_id, null: false

      t.timestamps
    end

    add_index :goods_comments, :id
  end
end
