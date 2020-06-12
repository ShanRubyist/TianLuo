class RemoveColumnFromShops < ActiveRecord::Migration[5.2]
  def change
    remove_column :shops, :sales_num, :string
    remove_column :shops, :goods_num, :string
  end
end
