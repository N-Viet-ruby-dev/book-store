# frozen_string_literal: true

module Manager
  class PasswordsController < Devise::PasswordsController
    layout "session"
  end
end
