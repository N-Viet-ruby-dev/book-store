# frozen_string_literal: true

module LoadEntity
  private

  def load_entity
    @categories = Category.limit(5)
    @authors = Author.limit(5)
    @notifications = current_or_guest_user.notifications.newest
  end
end
