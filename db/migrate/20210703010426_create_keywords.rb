class CreateKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :keywords do |t|
      t.integer :origin, default: 1, comment: '标记关键词来源，0:标题,1:摘要'
      t.string :word, comment: '关键词'
      t.timestamps
    end
    add_index :keywords, :id
    add_index :keywords, :word
  end
end
