class AddColumsToOrderDetail < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_details, :cart, foreign_key: true
  end
end
