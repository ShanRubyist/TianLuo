class ChangeGoodsImageToJson < ActiveRecord::Migration[5.2]
  def change
    add_column :goods_images, :goods_images, :json, default: {}
    remove_column :goods_images, :url, :string
  end
end
