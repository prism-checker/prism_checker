# frozen_string_literal: true

require_relative '../sections/select'

class Body < SitePrism::Section
  element :header, 'h2'
end

class Sections < SitePrism::Page
  set_url '/sections.html'

  section :header, 'div#header' do
    element :header, 'h1'
  end

  section :body, Body, 'div#body'

  sections :items, 'div.item' do
    element :content, 'span'
  end

  # def something_true
  #   true
  # end
  #
  # def something_false
  #   false
  # end
  #
  # def some_string
  #   'Foo'
  # end
  #
  # def some_array
  #   ['Foo']
  # end
  #
  # def some_number
  #   42
  # end
end
