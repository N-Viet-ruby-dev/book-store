# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      if cookies.signed[:guest_user_email]
        User.find_by!(email: cookies.signed[:guest_user_email])
      elsif env["warden"].user
        env["warden"].user
      else
        reject_unauthorized_connection
      end
    end
  end
end
