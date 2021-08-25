class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false, comment: '标签名称'

      t.timestamps
    end

    add_index :tags, :id
  end
end
