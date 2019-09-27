class AddGuestToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :guest_id, :integer
  end
end
