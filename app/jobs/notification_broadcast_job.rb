# frozen_string_literal: true

class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notify)
    ActionCable.server.broadcast "notifier_#{notify.order.user_id}_channel",
                                 content: render_notification(notify)
  end

  private

  def render_notification(notify)
    ApplicationController.render partial: "shared/notification", locals: { notify: notify }
  end
end
