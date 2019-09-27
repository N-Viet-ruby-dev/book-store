class AddAssigneeToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :assignee_id, :integer
  end
end
