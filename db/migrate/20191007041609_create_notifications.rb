class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :order, foreign_key: true
      t.text :content
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
