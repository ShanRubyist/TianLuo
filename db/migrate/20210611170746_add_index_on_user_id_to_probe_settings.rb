class AddIndexOnUserIdToProbeSettings < ActiveRecord::Migration[5.2]
  def change
    add_index :probe_settings, :user_id
  end
end
