# frozen_string_literal: true

require_relative '../sections/select'

class PageNotLoaded < SitePrism::Page
  set_url '/elements.html'

  element :header, 'h1'

  load_validation { false }
end
