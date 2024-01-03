# frozen_string_literal: true

require 'prism_checker/item_classifier'

module PrismChecker
  class ElementWrapper
    def initialize(element)
      @element = element
    end

    def class
      @element[:class]
    end

    def checked
      @element.checked?
    end

    def disabled
      @element.disabled?
    end

    def multiple
      @element.multiple?
    end

    def readonly
      @element.readonly?
    end

    def selected
      @element.selected?
    end

    def method_missing(method, *args)
      if @element.respond_to?(method)
        return @element.send(method, *args)
      end

      # if (ItemClassifier.element_checkbox?(@element) || ItemClassifier.element_radio?(@element)) && method == :checked
      #   return @element.checked?
      # end

      ret = @element[method]

      if ret.nil? && !method.start_with?('data-')
        # return '' if method.start_with?('data-')

        raise NoMethodError, "unknown attribute '#{method}'"
      end

      ret
    end

    def respond_to_missing?(*_args)
      true
    end
  end
end
