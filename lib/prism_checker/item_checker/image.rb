# frozen_string_literal: true

require_relative 'value_mixin/element_mixin'
require_relative 'value_mixin/image_mixin'
require_relative 'check_mixin/regexp'
require_relative 'check_mixin/string'

module PrismChecker
  module ItemChecker
    module Image
      class String
        extend ValueMixin::ImageValue
        extend CheckMixin::StringCheck2
      end

      class Regexp
        extend ValueMixin::ImageValue
        extend CheckMixin::RegexpCheck2
      end
    end
  end
end
