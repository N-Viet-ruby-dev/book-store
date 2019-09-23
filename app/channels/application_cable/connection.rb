# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags "ActionCable", current_user.id
      logger.add_tags "ActionCable", current_user.fullname
    end

    protected

    def find_verified_user
      if cookies.signed[:guest_user_email]
        verified_user = User.find_by!(email: cookies.signed[:guest_user_email])
      elsif env["warden"].user
        verified_user = env["warden"].user
      else
        reject_unauthorized_connection
      end
    end
  end
end
