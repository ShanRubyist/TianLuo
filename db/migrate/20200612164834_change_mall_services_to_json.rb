class ChangeMallServicesToJson < ActiveRecord::Migration[5.2]
  def change
    add_column :mall_services, :services, :json, default: {}
    remove_column :mall_services, :name, :string
  end
end
