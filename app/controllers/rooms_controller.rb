# frozen_string_literal: true

class RoomsController < ApplicationController
  def create
    @room = Room.find_or_create_by(name: "Room #{guest_user.email}", guest_id: guest_user.id)
    respond_to do |format|
      format.js
    end
  end
end
