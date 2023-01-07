# frozen_string_literal: true

require_relative 'item_value/element'
require_relative 'item_value/image'
require_relative 'item_check/regexp'
require_relative 'item_check/string'

module PrismChecker
  module ItemChecker
    module Image
      class String
        extend ItemValue::Image
        extend ItemCheck::String
      end

      class Regexp
        extend ItemValue::Image
        extend ItemCheck::Regexp
      end
    end
  end
end
