class AddColumnToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :phone_number, :string
    add_column :orders, :card_number, :string
  end
end
