# frozen_string_literal: true

require_relative 'base'
module PrismChecker
  module Node
    class Array < PrismChecker::Node::Base
      attr_reader :children

      def initialize(checker, parent, name, expectation)
        super
        @children = []
      end

      def add_child(idx, child)
        @children[idx] = child
      end

      def walk_through(level = 0, &block)
        yield self, level
        @children.each do |c|
          c.walk_through(level + 1, &block)
        end
      end
    end
  end
end
