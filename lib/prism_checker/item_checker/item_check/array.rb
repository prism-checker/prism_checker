# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemCheck
      module Array
        def check(_element, value, expectation)
          value.size == expectation.size
        end

        def error_message(elements, _value, expectation)
          "Wrong elements count\nActual: #{elements.size}\nExpected: #{expectation.size}"
        end
      end
    end
  end
end
