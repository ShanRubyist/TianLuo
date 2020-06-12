class CreateSkusExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :skus_extras do |t|
      t.string :spec, comment: '规格名称'
      t.decimal :normal_price, precision: 7, scale: 2, comment: '正常价'
      t.decimal :group_price, precision: 7, scale: 2, comment: '团购价'

      t.integer :sku_id, null: false

      t.timestamps
    end
  end
end
