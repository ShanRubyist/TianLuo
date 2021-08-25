class AddTfIdfTfidfToRssfeedKeywordShips < ActiveRecord::Migration[5.2]
  def change
    add_column :rssfeed_keyword_ships, :tf, :float
    add_column :rssfeed_keyword_ships, :idf, :float
    add_column :rssfeed_keyword_ships, :tf_idf, :float

    add_index :rssfeed_keyword_ships, :tf_idf
  end
end
