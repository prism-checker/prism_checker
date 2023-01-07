# frozen_string_literal: true

require_relative 'item_value/element'
require_relative 'item_value/input'
require_relative 'item_check/string'
require_relative 'item_check/regexp'

module PrismChecker
  module ItemChecker
    module Input
      class String
        extend ItemValue::Input
        extend ItemCheck::String
      end

      class Regexp
        extend ItemValue::Input
        extend ItemCheck::Regexp
      end
    end
  end
end
