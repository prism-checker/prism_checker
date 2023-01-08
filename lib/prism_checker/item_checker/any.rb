# frozen_string_literal: true

require_relative 'item_check/string'
require_relative 'item_check/regexp'
require_relative 'item_value/elements'

module PrismChecker
  module ItemChecker
    module Any
      class Any
        def self.value(value)
          value
        end

        def self.check(_checkbox, value, expectation)
          value == expectation
        end

        def self.error_message(_checkbox, value, expectation)
          "Expected: #{expectation}\nGot: #{value}"
        end
      end
    end
  end
end
