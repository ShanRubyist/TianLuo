class CreatePlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :platforms do |t|
      t.string :name, comment: '电商平台名称'

      t.timestamps
    end

    add_index :platforms, :name, unique: true
  end
end
