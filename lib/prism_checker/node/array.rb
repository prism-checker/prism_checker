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

      def check
        check_wrapper do
          check_expectation_compatibility
          check_array_size
        end
      end

      def check_expectation_compatibility
        unless element.is_a? ::Array
          raise Node::BadExpectation, mismatch_string(element, @expectation)
        end
      end

      def check_array_size
        if wait_until_true { element.size == @children.size }
          return
        end

        raise Node::CheckFail, "Wrong elements count\nActual: #{element.size}\nExpected: #{@children.size}"
      end
    end
  end
end
