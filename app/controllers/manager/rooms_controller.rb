# frozen_string_literal: true

module Manager
  class RoomsController < BaseController
    before_action :load_room, only: :show

    def index
      @rooms = current_user.assigned_rooms.opening
    end

    def show
      respond_to do |format|
        format.js
      end
    end

    private

    def load_room
      @room = Room.find(params[:id])
    end
  end
end
