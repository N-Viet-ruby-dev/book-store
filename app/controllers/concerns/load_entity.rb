# frozen_string_literal: true

module LoadEntity
  private

  def load_entity
    @book = Book.find(params[:id]) if params[:id]
    @categories = Category.limit(5)
    @authors = Author.limit(5)
  end
end
