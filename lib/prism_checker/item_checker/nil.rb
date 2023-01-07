# frozen_string_literal: true

require_relative 'item_check/string'
require_relative 'item_check/regexp'
require_relative 'item_value/string'

module PrismChecker
  module ItemChecker
    module Nil
      class String
        def self.value(_element); end

        def self.check(_element, _value, _expectation)
          false
        end

        def self.error_message(_element, _value, expectation)
          "Expected '#{expectation}', got nil"
        end
      end

      class Regexp
        def self.value(_element); end

        def self.check(_element, _value, _expectation)
          false
        end

        def self.error_message(_element, _value, expectation)
          "Expected '/#{expectation.source}/', got nil"
        end
      end
    end
  end
end
