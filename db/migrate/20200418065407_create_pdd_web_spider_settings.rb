class CreatePddWebSpiderSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :pdd_web_spider_settings do |t|
      t.string :url, null: false, comment: '网页地址'
      t.integer :port, default: 80, comment: '端口'
      t.integer :retry_limit, comment: '重试次数'
      t.string :proxy, comment: '代理服务器'
      t.string :cookies, comment: 'cookies'
      t.string :log_path, comment: '日志文件名'
      t.boolean :status, default: true, comment: '服务开关: 开启才会抓取'

      t.integer :user_id, null: false, comment: '用户ID'

      t.timestamps
    end

    add_index :pdd_web_spider_settings, :url
  end
end
