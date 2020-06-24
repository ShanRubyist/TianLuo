class CreateWebSpiderFailureHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :web_spider_failure_histories do |t|
      t.string :status, comment: '运行状态'
      t.string :reason, comment: '失败原因'
      t.string :detail, comment: '详细原因'

      t.integer :pdd_web_spider_setting_id, null:false
      t.timestamps
    end

    add_index :web_spider_failure_histories, :id
    add_index :web_spider_failure_histories, :pdd_web_spider_setting_id
  end
end