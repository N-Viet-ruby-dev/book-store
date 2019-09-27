# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  after_action :delete_guest, only: :create

  private

  def delete_guest
    return unless cookies[:guest_user_email]

    guest_user.delete
    cookies.delete :guest_user_email
  end
end
