# frozen_string_literal: true

module Manager
  class BaseController < ApplicationController
    layout "manager"
    before_action :authenticate_user!
  end
end
