class CreateMallServices < ActiveRecord::Migration[5.2]
  def change
    create_table :mall_services do |t|
      t.string :name, null: false, comment: '服务名称'

      t.integer :good_id, null: false

      t.timestamps
    end

    add_index :mall_services, :name
  end
end
