class CreateGoodsImages < ActiveRecord::Migration[5.2]
  def change
    create_table :goods_images do |t|
      t.string :url, comment: '图片链接'

      t.integer :good_id, null: false

      t.timestamps
    end
  end
end
