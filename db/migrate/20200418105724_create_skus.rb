class CreateSkus < ActiveRecord::Migration[5.2]
  def change
    create_table :skus do |t|
      t.string :skuid, comment: '平台SKU编码'
      t.string :spec, comment: '规格名称'
      t.integer :normal_price, comment: '正常价'
      t.integer :group_price, comment: '团购价'

      t.integer :good_id, null: false

      t.timestamps
    end

    add_index :skus, :skuid
  end
end
