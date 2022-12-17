# frozen_string_literal: true

require_relative '../sections/select'

class Elements < SitePrism::Page
  set_url '/elements.html{?config*}'
  # set_url_matcher(/elements\.html$/)


  element :image, 'img'
  element :button, 'button'
  element :input, 'input#input'
  element :textarea, 'textarea'
  element :checkbox_checked, 'input#input-checkbox-checked'
  element :checkbox_unchecked, 'input#input-checkbox-unchecked'
  element :select_selected, 'select#select-selected'
  element :select_unselected, 'select#select-unselected'

  section :select_selected1, Select, 'select#select-selected'
  section :select_unselected1, Select, 'select#select-unselected'

  # load_validation { has_header? }
end
