# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemCheck
      module EmptyArray
        def check(_element, value, _expectation)
          value.empty?
        end

        def error_message(_element, _value, _expectation)
          'Expected to be empty'
        end
      end
    end
  end
end
