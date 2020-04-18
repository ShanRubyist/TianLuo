class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.string :name, null: false, comment: '优惠卷名称'

      t.integer :good_id, null: false
      t.timestamps
    end

    add_index :coupons, :name
  end
end
