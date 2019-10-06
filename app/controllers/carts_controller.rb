# frozen_string_literal: true

class CartsController < ApplicationController
  include CurrentCart
  before_action :load_cart
  before_action :load_book, only: :add_book

  def add_book
    @order_detail = @cart.add_book(@book)
    @order_detail.save! if @order_detail.errors.empty?
    respond_to do |format|
      format.js do
        helpers.form_for @cart do |f|
          f.fields_for :order_details do |ff|
            @item = render_to_string partial: "shared/order_detail", locals: { f: ff, detail: @order_detail }
          end
        end
      end
    end
  end

  def update
    @cart.update(cart_params)
    respond_to do |format|
      format.js
    end
  end

  private

  def cart_params
    params.require(:cart).permit(order_details_attributes: %i[id quantity _destroy])
  end

  def load_book
    @book = Book.find(params[:book_id]) if params[:book_id]
    return if @book

    redirect_to books_url, notice: t("invalid_book")
  end
end
