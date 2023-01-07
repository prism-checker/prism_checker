# frozen_string_literal: true

require_relative 'item_check/string'
require_relative 'item_check/regexp'
require_relative 'item_value/elements'

module PrismChecker
  module ItemChecker
    module Elements
      class String
        extend ItemValue::Elements
        extend ItemCheck::String
      end

      class Regexp
        extend ItemValue::Elements
        extend ItemCheck::Regexp
      end

      class Array
        def self.value(elements)
          elements
        end

        def self.check(elements, _value, expectation)
          elements.size == expectation.size
        end

        def self.error_message(elements, _value, expectation)
          "Wrong elements count\nActual: #{elements.size}\nExpected: #{expectation.size}"
        end
      end
    end
  end
end
