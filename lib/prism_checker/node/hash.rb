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

      def check
        check_wrapper do
          check_expectation_compatibility

          if element.is_a?(SitePrism::Page)
            check_page_loaded?
          else
            check_element_visible?
          end
        end
      end

      def check_expectation_compatibility
        allowed = [Capybara::Node::Element, SitePrism::Page, SitePrism::Section]

        unless allowed.map { |c| element.is_a?(c) }.any?
          raise Node::BadExpectation, mismatch_string(element, @expectation)
        end
      end
    end
  end
end
