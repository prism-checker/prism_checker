# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemCheck
      module Number
        def check(_elements, value, expectation)
          value == expectation
        end

        def error_message(_elements, value, expectation)
          "Wrong elements count\nActual: #{value}\nExpected: #{expectation}"
        end
      end
    end
  end
end
