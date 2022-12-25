# frozen_string_literal: true

module PrismChecker
  class ElementWrapper
    def initialize(element)
      @element = element
    end

    def class
      @element[:class]
    end

    def method_missing(method, *args)
      if @element.respond_to?(method)
        return @element.send(method, *args)
      end

      if @element.tag_name == 'input' && @element['type'] == 'checkbox' && method == :checked
        return @element.checked?
      end

      @element[method]
    end

    def respond_to_missing?(*_args)
      true
    end
  end
end
