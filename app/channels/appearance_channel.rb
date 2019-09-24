# frozen_string_literal: true

class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    current_user.update(online: true)
    stream_from "AppearanceChannel"
  end

  def unsubscribed
    current_user.update(online: false)
  end
end
