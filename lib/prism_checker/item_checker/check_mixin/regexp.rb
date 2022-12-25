# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module CheckMixin
      module RegexpCheck2
        def check(_element, value, expectation)
          value =~ expectation
        end

        def error_message(_element, value, expectation)
          "Expected '#{value}' to match '/#{expectation.source}/'"
        end
      end
    end
  end
end
