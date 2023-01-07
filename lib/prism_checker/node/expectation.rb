# frozen_string_literal: true

require_relative 'base'
require_relative '../item_classifier'
require_relative '../check_dispatcher'

module PrismChecker
  module Node
    class Expectation < PrismChecker::Node::Base
      def walk_through(level = 0)
        yield self, level
      end
    end
  end
end
