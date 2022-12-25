# frozen_string_literal: true

require_relative 'value_mixin/element_mixin'
require_relative 'value_mixin/input_mixin'
require_relative 'check_mixin/string'
require_relative 'check_mixin/regexp'

module PrismChecker
  module ItemChecker
    module Input
      class String
        extend ValueMixin::InputValue
        extend CheckMixin::StringCheck2
      end

      class Regexp
        extend ValueMixin::InputValue
        extend CheckMixin::RegexpCheck2
      end
    end
  end
end
