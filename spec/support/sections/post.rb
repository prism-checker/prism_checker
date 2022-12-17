# frozen_string_literal: true

class Post < SitePrism::Section
  element :title, 'h3'
  element :content, '.post__content'
  element :date_time, '.post__date-time'

  def date
    date_time.text.split.first
  end
end
