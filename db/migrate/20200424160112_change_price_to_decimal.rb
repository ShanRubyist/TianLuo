class ChangePriceToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :skus, :normal_price, :decimal, precision: 7, scale: 2
    change_column :skus, :group_price, :decimal, precision: 7, scale: 2
  end
end
