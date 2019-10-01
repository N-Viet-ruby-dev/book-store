class AddOpenToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :status, :integer, default: 0
  end
end
