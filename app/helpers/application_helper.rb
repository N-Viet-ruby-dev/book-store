# frozen_string_literal: true

module ApplicationHelper
  def active?(path)
    "active" if current_page?(path)
  end

  def nav_items
    [
      {
        url: books_path,
        title: " Books"
      }
    ]
  end

  def nav_helper
    nav_links = ""

    nav_items.each_with_index do |item, idx|
      nav_links += "<li class='navigation__item'><a href='#{item[:url]}' class='navigation__link'><span>
        #{idx + 1}.</span>#{item[:title]}</a></li>"
    end

    nav_links.html_safe
  end
end
