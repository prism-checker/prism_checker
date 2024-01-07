# frozen_string_literal: true

require_relative 'item_check/string'
require_relative 'item_check/regexp'
require_relative 'item_check/empty_array'
require_relative 'item_value/array'

module PrismChecker
  module ItemChecker
    module Array
      class String
        extend ItemValue::Array
        extend ItemCheck::String
      end

      class Empty
        extend ItemValue::Array
        extend ItemCheck::EmptyArray
      end

      class Regexp
        extend ItemValue::Array
        extend ItemCheck::Regexp
      end
    end
  end
end
