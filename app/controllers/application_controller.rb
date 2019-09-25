# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include AuthorizationHelper

  before_action :load_user

  private

  def load_user
    @user = current_or_guest_user
  end
end
