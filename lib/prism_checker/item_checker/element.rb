# frozen_string_literal: true

require_relative 'value_mixin/element_mixin'
require_relative 'check_mixin/regexp'
require_relative 'check_mixin/string'

module PrismChecker
  module ItemChecker
    module Element

      class String
        extend ValueMixin::ElementValue2
        extend CheckMixin::StringCheck2
      end

      class Regexp
        extend ValueMixin::ElementValue2
        extend CheckMixin::RegexpCheck2
      end

      class Visible
        def self.value(_element); end

        def self.check(element, _value, _expectation)
          element.visible?
        end

        def self.error_message(_element, _value, _expectation)
          'Element is not visible'
        end
      end

      class Invisible
        def self.value(_element); end

        def self.check(element, _value, _expectation)
          !element.visible?
        end

        def self.error_message(_element, _value, _expectation)
          'Element is visible'
        end
      end
    end
  end
end
