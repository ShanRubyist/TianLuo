class CreateDsrs < ActiveRecord::Migration[5.2]
  def change
    create_table :dsrs do |t|
      t.integer :logistics_score, default: nil, comment: '物流评分'
      t.integer :desc_score, default: nil, comment: '描述评分'
      t.integer :service_score, default: nil, comment: '服务评分'
      t.integer :logistics_rank_percent, default: nil, comment: '物流排行'
      t.integer :desc_rank_percent, default: nil, comment: '描述排行'
      t.integer :service_rank_percent, default: nil, comment: '服务排行'
      t.integer :logistics_rank_status, default: nil, comment: '物流排行状态'
      t.integer :desc_rank_status, default: nil, comment: '描述排行状态'
      t.integer :service_rank_status, default: nil, comment: '服务排行状态'

      t.integer :shop_id, null: false, comment: '关联店铺'

      t.timestamps
    end

    add_index :dsrs, :id
  end
end
