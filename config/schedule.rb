# frozen_string_literal: true

every 1.months do
  rake "user:destroy_guest_user"
end
