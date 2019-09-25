# frozen_string_literal: true

class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    current_user.online!
    stream_from "AppearanceChannel"
  end

  def unsubscribed
    current_user.offline!
  end
end
