# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module CheckMixin
      module StringCheck2
        def check(_element, value, expectation)
          value.to_s.include?(expectation)
        end

        def error_message(_element, value, expectation)
          "Expected '#{value}' to include '#{expectation}'"
        end
      end
    end
  end
end

