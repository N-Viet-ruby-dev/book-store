# frozen_string_literal: true

module AuthorizationHelper
  def current_or_guest_user
    current_user || guest_user
  end

  def guest_user
    @cached_guest_user ||=
      User.find_by!(email: (cookies.signed[:guest_user_email] || create_guest_user.email))
  rescue ActiveRecord::RecordNotFound
    cookies.delete :guest_user_email
    guest_user
  end

  private

  def create_guest_user
    user = User.create(fullname: "guest", email: "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    cookies.signed[:guest_user_email] = { value: user.email, expires: 1.month.from_now }
    user.save!(validate: false)
    user
  end
end
