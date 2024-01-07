# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemCheck
      module String
        def check(_element, value, expectation)
          if PrismChecker.string_comparison == :inclusion
            value.to_s.include?(expectation)
          else
            value == expectation
          end
        end

        def error_message(_element, value, expectation)
          if PrismChecker.string_comparison == :inclusion
            "Expected '#{value}' to include '#{expectation}'"
          else
            "Expected '#{value}' to be equal '#{expectation}'"
          end
        end
      end
    end
  end
end
