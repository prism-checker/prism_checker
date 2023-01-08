# frozen_string_literal: true

require_relative './iframe_blog'

class IframePage < SitePrism::Page
  set_url '/iframe.html'

  iframe :blog_iframe, IframeBlog, '#iframe' do

  end
end
