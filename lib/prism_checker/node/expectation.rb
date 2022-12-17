# frozen_string_literal: true

require_relative 'base'

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

          if element.is_a?(SitePrism::Section)
            if @expectation == :invisible
              if wait_until_true { element.visible? }
                raise Node::CheckFail, 'Element is visible'
              end
              return
            end

            check_allowed_expectations

            check_element_visible?
            check_prism_section
          elsif element.is_a?(SitePrism::Page)
            check_allowed_expectations
            check_page_loaded?
            check_prism_page
          elsif element.is_a?(::Array)
            check_allowed_expectations
            check_array
          elsif element.is_a?(Capybara::Node::Element)
            if element_image?
              check_allowed_expectations
              check_image
            elsif element_checkbox?
              check_checkbox_allowed_expectations
              check_checkbox
            elsif element_input?
              check_allowed_expectations
              check_input
            elsif element_select?
              check_allowed_expectations
              check_select
            else
              check_allowed_expectations
              check_capybara_element
            end
          else
            # check_allowed_expectations
            check_default
          end
        end
      end

      def check_allowed_expectations
        allowed = [String, Regexp, RSpec::Matchers::BuiltIn::BaseMatcher] # TODO: :invisible, :absent

        unless allowed.map{|c| @expectation.is_a?(c)}.any?
          raise Node::BadExpectation, mismatch_string(element, @expectation)
        end
      end

      def check_checkbox_allowed_expectations
        allowed = [TrueClass, FalseClass]

        unless allowed.map{|c| @expectation.is_a?(c)}.any?
          raise Node::BadExpectation, mismatch_string(element, @expectation, %w[true false])
        end
        return
      end

      def check_default
        check_value do
          element
        end
      end

      def check_array
        check_value do
          begin
            element.map(&:text).join(' ')
          rescue StandardError # TODO
            element.map(&:to_s).join(' ')
          end
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

        if @expectation.is_a?(String)
          if wait_until_true do
            value = yield
            value.to_s.include?(@expectation)
          end
            return
          end

          raise Node::CheckFail, "Expected '#{value.to_s}' to include '#{@expectation}'"
        elsif @expectation.is_a?(Regexp)
          if wait_until_true do
            value = yield
            value.to_s =~ @expectation
          end
            return
          end

          raise(Node::CheckFail, "Expected '#{value.to_s}' to match '/#{@expectation.source}/'")
        elsif @expectation.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)

          if wait_until_true do
            value = yield
            @expectation.matches?(value)
          end
            return
          end

          raise Node::CheckFail, @expectation.failure_message.chomp.sub(/$\n/, '')
        else
          if wait_until_true do
            value = yield
            value == @expectation
          end
            return
          end

          raise(Node::CheckFail, "Expected #{value} (#{value.class.name}) to equal #{@expectation} (#{@expectation.class.name})")
        end

      end

      def element_image?
        element.is_a?(Capybara::Node::Element) && element.tag_name == 'img'
      end

      def element_input?
        element.is_a?(Capybara::Node::Element) && element.tag_name == 'input'
      end

      def element_select?
        element.is_a?(Capybara::Node::Element) && element.tag_name == 'select'
      end

      def element_checkbox?
        element_input? && element['type'] == 'checkbox'
      end
    end
  end
end
