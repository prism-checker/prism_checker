# frozen_string_literal: true

require_relative '../sections/select'

class Elements < SitePrism::Page
  set_url '/elements.html'

  element :header, 'h1'
  element :image, 'img.logo'
  element :button, 'button'
  element :input, 'input#input'
  element :input_button, 'input#input-button'
  element :textarea, 'textarea'
  element :checkbox, 'input#input-checkbox-checked'
  element :checkbox_checked, 'input#input-checkbox-checked'
  element :checkbox_unchecked, 'input#input-checkbox-unchecked'
  element :select, 'select#select-selected'
  element :select_selected, 'select#select-selected'
  element :select_unselected, 'select#select-unselected'

  elements :inputs, 'input'
  elements :text_elements, 'div.text-element'
  elements :images, 'img.image'

  def inputs_value
    inputs.map(&:value)
  end

  # section :select_selected1, Select, 'select#select-selected'
  # section :select_unselected1, Select, 'select#select-unselected'

  # load_validation { has_header? }
end
