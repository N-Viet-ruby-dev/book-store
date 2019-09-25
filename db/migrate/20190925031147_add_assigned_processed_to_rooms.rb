class AddAssignedProcessedToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :assigned, :boolean, default: false
    add_column :rooms, :processed, :boolean, default: false
  end
end
