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

  element :radio_selected, 'input#radio1'
  element :radio_unselected, 'input#radio2'

  def inputs_value
    inputs.map(&:value)
  end

  def empty_string
    ''
  end

  def some_string
    'String'
  end

  def some_array
    [1, 2, 3]
  end

  def empty_array
    []
  end

  def number
    1
  end
end
