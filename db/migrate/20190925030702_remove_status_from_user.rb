class RemoveStatusFromUser < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :online
  end

  def down
    add_column :users, :online, :boolean
  end
end
