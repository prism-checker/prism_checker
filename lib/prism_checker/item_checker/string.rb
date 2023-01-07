# frozen_string_literal: true

require_relative 'item_check/string'
require_relative 'item_check/regexp'
require_relative 'item_value/string'

module PrismChecker
  module ItemChecker
    module String
      class String
        extend ItemValue::String
        extend ItemCheck::String
      end

      class Regexp
        extend ItemValue::String
        extend ItemCheck::Regexp
      end
    end
  end
end
