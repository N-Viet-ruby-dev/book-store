class SessionsController < Devise::SessionsController
  after_action :delete_guest, only: :create

  private

  def delete_guest
    if cookies.delete :guest_user_email
      guest_user.delete
      cookies.delete :guest_user_email
    end
  end
end
