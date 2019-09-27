class AddStatusToRoomMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :room_messages, :status, :integer, default: 0
  end
end
