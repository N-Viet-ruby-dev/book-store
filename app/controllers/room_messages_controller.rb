# frozen_string_literal: true

class RoomMessagesController < ApplicationController
  def create
    @message = current_user.room_messages.build(room_message_params)
  end

  private

  def room_message_params
    params.require(:room_message).permit(:message)
  end
end
