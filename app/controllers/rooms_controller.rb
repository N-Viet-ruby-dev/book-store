# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :load_room, only: :show

  def index
    @rooms = current_user.assigned_rooms if current_user&.admin?
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def create
    @room = Room.find_or_create_by(name: "Room #{guest_user.email}")
    respond_to do |format|
      format.js
    end
  end

  private

  def load_room
    @room = Room.find(params[:id])
  end
end
