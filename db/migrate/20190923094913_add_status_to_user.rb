class AddStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :online, :boolean, default: 0
  end
end
