class ChangeDsrToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :dsrs, :logistics_score, :decimal, precision: 3, scale: 2
    change_column :dsrs, :desc_score, :decimal, precision: 3, scale: 2
    change_column :dsrs, :service_score, :decimal, precision: 3, scale: 2

    change_column :dsrs, :logistics_rank_percent, :decimal, precision: 5, scale: 2
    change_column :dsrs, :desc_rank_percent, :decimal, precision: 5, scale: 2
    change_column :dsrs, :service_rank_percent, :decimal, precision: 5, scale: 2
  end
end
