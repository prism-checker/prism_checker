# frozen_string_literal: true

require_relative '../sections/post'

class Blog < SitePrism::Page
  set_url '/blog.html{?config*}'
  set_url_matcher(/blog\.html$/)

  element :header, 'h1'
  element :logo, 'img.logo'

  section :posts, '.posts-holder' do
    element :header, 'h2'
    sections :post, Post, '.post'
  end

  section :records, '.records' do
    elements :record, '.record'
  end

  def post_dates
    posts.post.map(&:date)
  end

  load_validation { has_header? }
end
