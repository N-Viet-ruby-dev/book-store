# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include AuthorizationHelper

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || manager_root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
