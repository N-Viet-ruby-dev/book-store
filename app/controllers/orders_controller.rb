# frozen_string_literal: true

class OrdersController < ApplicationController
  include CurrentCart
  include LoadEntity
  before_action :load_entity, only: %i[show new create]
  before_action :load_cart, only: %i[new create]
  before_action :ensure_cart_isnt_empty, only: %i[new create]
  before_action :load_order, only: :show

  def show
    @order.notifications.update_all(status: :seen)
  end

  def new
    @order = Order.new
  end

  def create
    @order = current_or_guest_user.orders.build(order_params)
    @order.add_order_details_from_cart(@cart)
    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      redirect_to books_url, notice: t("process_order")
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :email, :address, :phone_number, :card_number)
  end

  def ensure_cart_isnt_empty
    redirect_to books_url, notice: t("cart_empty") if @cart.order_details.empty?
  end

  def load_order
    @order = Order.find(params[:id])
  end
end
