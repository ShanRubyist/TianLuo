class ChangeCuponsToJson < ActiveRecord::Migration[5.2]
  def change
    add_column :coupons, :coupons, :json, default: {}
    remove_column :coupons, :name, :string, null: false
  end
end
