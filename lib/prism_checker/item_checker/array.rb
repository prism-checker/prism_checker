# frozen_string_literal: true

require_relative 'check_mixin/string'
require_relative 'check_mixin/regexp'
require_relative 'value_mixin/array_mixin'

module PrismChecker
  module ItemChecker
    module Array
      class String
        extend ValueMixin::ArrayValue
        extend CheckMixin::StringCheck2
      end

      class Regexp
        extend ValueMixin::ArrayValue
        extend CheckMixin::RegexpCheck2
      end
    end
  end
end
