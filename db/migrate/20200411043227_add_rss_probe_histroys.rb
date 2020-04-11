class AddRssProbeHistroys < ActiveRecord::Migration[5.2]
  def change
    create_table :rss_probe_histories do |t|
      t.string :title, comment: 'RSS源标头'
      t.string :description, comment: 'RSS源描述'
      t.datetime :last_build_date, comment: 'RSS列表最近创建时间'
      t.string :link, comment: '连接地址'

      t.integer :probe_setting_id, null: false

      t.timestamps
    end
  end
end
