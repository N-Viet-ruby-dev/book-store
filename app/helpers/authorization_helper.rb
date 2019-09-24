# frozen_string_literal: true

module AuthorizationHelper
  def current_or_guest_user
    if current_user
      if cookies.signed[:guest_user_email]
        guest_user.delete
        cookies.delete :guest_user_email
      end
      current_user
    else
      guest_user
    end
  end

  def guest_user
    @cached_guest_user ||=
      User.find_by!(email: (cookies.permanent.signed[:guest_user_email] ||= create_guest_user.email))
  rescue ActiveRecord::RecordNotFound
    cookies.delete :guest_user_email
    guest_user
  end

  private

  def create_guest_user
    user = User.create(fullname: "guest", email: "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    user.save!(validate: false)
    user
  end
end
