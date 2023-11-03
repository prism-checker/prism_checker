# frozen_string_literal: true

require_relative '../sections/post'

class Performance < SitePrism::Page
  set_url '/performance.html'
  set_url_matcher(/performance\.html$/)

  element :header, 'h1'

  section :ol1, 'ol.ol-lvl-1' do
    sections :li1, 'li.li-lvl-1' do
      section :ul2, 'ul.ul-lvl-2' do
        sections :li2, 'li.li-lvl-2' do
          sections :div3, 'div.div-lvl-3' do
            element :span3, 'span'
            element :p3, 'p'
          end
        end
      end
    end
  end

  load_validation { has_header? }
end
