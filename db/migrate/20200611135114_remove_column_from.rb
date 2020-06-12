class RemoveColumnFrom < ActiveRecord::Migration[5.2]
  def change
    remove_column :skus, :spec, :string
    remove_column :skus, :normal_price, :decimal, precision: 7, scale: 2
    remove_column :skus, :group_price, :decimal, precision: 7, scale: 2
  end
end
