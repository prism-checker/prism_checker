# frozen_string_literal: true

require_relative 'check_mixin/string'
require_relative 'check_mixin/regexp'
require_relative 'value_mixin/string_mixin'

module PrismChecker
  module ItemChecker
    module String
      class String
        extend ValueMixin::StringValue
        extend CheckMixin::StringCheck2
      end

      class Regexp
        extend ValueMixin::StringValue
        extend CheckMixin::RegexpCheck2
      end
    end
  end
end
