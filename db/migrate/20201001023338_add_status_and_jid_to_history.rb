class AddStatusAndJidToHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :rss_probe_histories, :status, :string, comment: 'job 状态'
    add_column :rss_probe_histories, :detail, :string, comment: '详细说明'
    add_column :rss_probe_histories, :jid, :string, comment: 'sidekiq job id'

    add_index :rss_probe_histories, :jid
  end
end
