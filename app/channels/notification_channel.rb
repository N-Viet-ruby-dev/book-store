# frozen_string_literal: true

class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifier_#{params['notifier_id']}_channel"
  end

  def unsubscribed; end
end
