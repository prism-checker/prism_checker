# frozen_string_literal: true

require_relative 'item_check/string'
require_relative 'item_check/regexp'
require_relative 'item_value/elements'

module PrismChecker
  module ItemChecker
    module Checkbox
      class Boolean
        def self.value(checkbox)
          checkbox.checked?
        end

        def self.check(_checkbox, value, expectation)
          value == expectation
        end

        def self.error_message(_checkbox, value, expectation)
          if expectation
            'Expected to be checked'
          else
            'Expected to be unchecked'
          end
        end
      end
    end
  end
end
