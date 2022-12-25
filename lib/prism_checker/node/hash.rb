# frozen_string_literal: true

require_relative 'base'

module PrismChecker
  module Node
    class Hash < PrismChecker::Node::Base
      attr_reader :children

      def initialize(checker, parent, name, expectation)
        super
        @children = {}
      end

      def add_child(name, child)
        @children[name] = child
      end

      def walk_through(level = 0, &block)
        yield self, level
        @children.each_value do |child|
          child.walk_through(level + 1, &block)
        end
      end
    end
  end
end
