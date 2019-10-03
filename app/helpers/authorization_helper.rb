# frozen_string_literal: true

module AuthorizationHelper
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  def guest_user(with_retry = true)
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  private

  def create_guest_user
    u = User.new(:fullname => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

end
