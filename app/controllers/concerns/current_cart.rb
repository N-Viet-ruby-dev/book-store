# frozen_string_literal: true

module CurrentCart
  private

  def load_cart
    @cart = Cart.includes(:order_details, :books).find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
