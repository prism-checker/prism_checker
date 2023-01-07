# frozen_string_literal: true

require_relative 'item_value/element'
require_relative 'item_check/regexp'
require_relative 'item_check/string'

module PrismChecker
  module ItemChecker
    module Element

      class String
        extend ItemValue::Element
        extend ItemCheck::String
      end

      class Regexp
        extend ItemValue::Element
        extend ItemCheck::Regexp
      end

      class Visible
        def self.value(_element); end

        def self.check(element, _value, _expectation)
          element.visible?
        end

        def self.error_message(_element, _value, _expectation)
          'Element is not visible'
        end
      end

      class Invisible
        def self.value(_element); end

        def self.check(element, _value, _expectation)
          !element.visible?
        end

        def self.error_message(_element, _value, _expectation)
          'Element is visible'
        end
      end
    end
  end
end
