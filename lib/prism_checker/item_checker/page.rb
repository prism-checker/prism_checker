# frozen_string_literal: true

require_relative 'item_value/page'
require_relative 'item_check/string'
require_relative 'item_check/regexp'

module PrismChecker
  module ItemChecker
    module Page
      class String
        extend ItemValue::Page
        extend ItemCheck::String
      end

      class Empty
        extend ItemValue::Page
        extend ItemCheck::Empty
      end

      class Regexp
        extend ItemValue::Page
        extend ItemCheck::Regexp
      end

      class Loaded
        def self.value(_element); end

        def self.check(page, _value, _expectation)
          page.loaded?
        end

        def self.error_message(_element, _value, _expectation)
          'Page is not loaded'
        end
      end
    end
  end
end
