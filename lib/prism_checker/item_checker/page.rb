# frozen_string_literal: true

require_relative 'value_mixin/page_mixin'
require_relative 'check_mixin/string'
require_relative 'check_mixin/regexp'

module PrismChecker
  module ItemChecker
    module Page
      class String2
        extend PageMixin::PageValue2
        extend CheckMixin::StringCheck2
      end

      class Regexp2
        extend PageMixin::PageValue2
        extend CheckMixin::RegexpCheck2
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
