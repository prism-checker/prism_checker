# frozen_string_literal: true

require_relative 'item_value/textarea'
require_relative 'item_check/string'
require_relative 'item_check/regexp'

module PrismChecker
  module ItemChecker
    module Textarea
      class String
        extend ItemValue::Textarea
        extend ItemCheck::String
      end

      class Empty
        extend ItemValue::Textarea
        extend ItemCheck::Empty
      end

      class Regexp
        extend ItemValue::Textarea
        extend ItemCheck::Regexp
      end
    end
  end
end
