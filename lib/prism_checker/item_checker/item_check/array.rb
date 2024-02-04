# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemCheck
      module Array
        def check(_element, value, expectation)
          value.size == expectation.size
        end

        def error_message(_element, value, expectation)
          "Expected '#{value}' to be equal '#{expectation}'"
        end
      end
    end
  end
end
