# frozen_string_literal: true

class Select < SitePrism::Section
  elements :options, 'option'

  def selected_option
    options.find{|o| o['selected'] }
  end
end
