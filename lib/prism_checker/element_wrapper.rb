# frozen_string_literal: true

module PrismChecker
  class ElementWrapper
    def initialize(element)
      @element = element
    end

    def method_missing(method, *args)
      # puts "method_missing #{method}"
      # byebug
      if @element.tag_name == 'input' && @element['type'] == 'checkbox' && method == :checked
        return @element.checked?
      end

      @element[method]
    end
  end
end
