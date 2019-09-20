class RoomsController < ApplicationController
  before_action :authenticate_user!

  before_action :load_entities, except: [:edit, :update, :destroy]

  def index
  end

  def show
    @room_message = RoomMessage.new
  end

  def create
    @room = Room.new(name: "Room_#{ Room.last.id + 1 }")
    @room.save
    respond_to do |format|
      format.js
    end
  end

  protected

  def load_entities
    @rooms = Room.all
    @room = Room.includes(:room_messages, :users).find(params[:id])
  end
end
