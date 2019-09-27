class RemoveStatusFromRoom < ActiveRecord::Migration[5.2]
  def up
    remove_column :rooms, :status
  end

  def down
    add_column :rooms, :status, :integer
  end
end
