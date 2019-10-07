class RenameColumnAndChangeColumnDefaultToBooks < ActiveRecord::Migration[5.2]
  def up
    rename_column :books, :total, :quantity
    change_column_default :books, :quantity, default: 0
  end
end
