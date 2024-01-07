# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemCheck
      module Empty
        def check(_element, value, _expectation)
          value.empty?
        end

        def error_message(_element, value, _expectation)
          "Expected '#{value}' to be empty"
        end
      end
    end
  end
end
