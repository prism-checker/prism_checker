# frozen_string_literal: true

require_relative 'check_mixin/string'
require_relative 'check_mixin/regexp'
require_relative 'value_mixin/elements_mixin'

module PrismChecker
  module ItemChecker
    module Elements
      class String
        extend ValueMixin::ElementsValue2
        extend CheckMixin::StringCheck2
      end

      class Regexp
        extend ValueMixin::ElementsValue2
        extend CheckMixin::RegexpCheck2
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
