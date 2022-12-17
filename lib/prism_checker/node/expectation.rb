# frozen_string_literal: true

require_relative 'base'
require_relative '../element_classifier'

module PrismChecker
  module Node
    class Expectation < PrismChecker::Node::Base
      def walk_through(level = 0)
        yield self, level
      end

      def check
        check_wrapper do
          if @expectation == :absent
            wait_until_true do
              element.visible?
            rescue Capybara::ElementNotFound
              return
            end

            raise Node::CheckFail, 'Element is present'
          end

          case ElementClassifier.classify(element)
          when :section
            if @expectation == :invisible
              raise Node::CheckFail, 'Element is visible' if wait_until_true { element.visible? }

              return
            end

            check_allowed_expectations
            check_element_visible?
            check_prism_section
          when :page
            check_allowed_expectations
            check_page_loaded?
            check_prism_page
          when :element
            check_allowed_expectations
            check_capybara_element
          when :image
            check_allowed_expectations
            check_image
          when :input
            check_allowed_expectations
            check_input
          when :select
            check_allowed_expectations
            check_select
          when :checkbox
            check_checkbox_allowed_expectations
            check_checkbox
          when :array
            check_allowed_expectations
            check_array
          else
            check_default
          end
        end
      end

      def check_allowed_expectations
        allowed = [String, Regexp, RSpec::Matchers::BuiltIn::BaseMatcher] # TODO: :invisible, :absent

        raise Node::BadExpectation, mismatch_string(element, @expectation) unless allowed.map { |c| @expectation.is_a?(c) }.any?
      end

      def check_checkbox_allowed_expectations
        allowed = [TrueClass, FalseClass]

        unless allowed.map { |c| @expectation.is_a?(c) }.any?
          raise Node::BadExpectation, mismatch_string(element, @expectation, %w[true false])
        end
      end

      def check_default
        check_value do
          element
        end
      end

      def check_array
        check_value do
          element.map(&:text).join(' ')
        rescue StandardError # TODO
          element.map(&:to_s).join(' ')
        end
      end

      def check_capybara_element
        check_value { element.text.to_s }
      end

      def check_prism_section
        check_value { element.text.to_s }
      end

      def check_prism_page
        check_value { element.find('body')&.text || element.text }
      end

      def check_image
        check_value { element['src'] }
      end

      def check_checkbox
        check_value { element.checked? }
      end

      def check_input
        check_value { element.value }
      end

      def check_select
        value = nil
        if wait_until_true do
          value = element.value
          value == @expectation
        end
          return
        end

        raise(Node::CheckFail, "Expected '#{value}' (#{value.class.name}) to equal '#{@expectation}' (#{@expectation.class.name})")
      end

      def check_value
        value = nil
        expectation_checker = checker.expectation_checkers.find(@expectation)

        result = wait_until_true do
          value = yield
          expectation_checker[:check].call(@expectation, value)
        end

        raise Node::CheckFail, expectation_checker[:error_message].call(@expectation, value) unless result
      end
    end
  end
end
