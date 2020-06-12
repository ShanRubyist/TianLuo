class RemoveColumnFromGoods < ActiveRecord::Migration[5.2]
  def change
    remove_column :goods, :name, :string
    remove_column :goods, :sales_num, :string
    remove_column :goods, :goods_comments_count, :integer
    remove_column :goods, :comments_total_num, :string
  end
end
