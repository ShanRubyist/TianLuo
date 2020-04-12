class CreateRssProbeFailureHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :rss_probe_failure_histories do |t|
      t.string :status, comment: '运行状态'
      t.string :reason, comment: '失败原因'
      t.string :detail, comment: '详细原因'

      t.integer :probe_setting_id, null: false

      t.timestamps
    end

    add_index :rss_probe_failure_histories, :id
  end
end
