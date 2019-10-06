class ChangeColumnDefaultToOrder < ActiveRecord::Migration[5.2]
  def up
    change_column :orders, :total_price, :float, default: 0
  end

  def down
    change_column :orders, :total_price, :float, default: nil
  end
end
