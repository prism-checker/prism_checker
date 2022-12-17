# frozen_string_literal: true

require_relative 'check_fail'
require_relative 'bad_expectation'
require_relative '../element_wrapper'

module PrismChecker
  module Node
    class Base
      attr_reader :name, :status, :message, :parent, :checker, :colorizer

      def initialize(checker, parent, name, expectation)
        @parent = parent
        @checker = checker
        @name = name
        @expectation = expectation
        @element = nil
        @status = 'Not checked'
        @element_done = false
        @error = nil
        @colorizer = checker.colorizer
      end

      def root?
        parent.is_a?(Checker)
      end

      def failure?
        @status == 'Fail' || @status == 'Error'
      end

      def success?
        @status == 'Ok'
      end

      def element
        if root?
          @checker.item
        elsif parent.element.is_a?(Capybara::Node::Element)
          ElementWrapper.new(parent.element).send(@name)
        else
          parent.is_a?(Node::Hash) ? parent.element.send(@name) : parent.element.send(:[], @name)
        end
      end

      def padding(level)
        '  ' * level
      end

      def key_padding(key)
        return '' if key.to_s.length == 0

        ' ' * (key.to_s.length + 2)
      end

      def status_padding
        ' ' * (status.length + 2)
      end

      def report(level, key)
        if failure?
          return @colorizer.wrap("#{status}: #{format_error_message(@error.message, level, key)}", :failure)
        end

        if success?
          return @colorizer.wrap(status, :success)
        end

        @colorizer.wrap(status, :detail)
      end

      def format_error_message(message, level, key)
        message.lines.map.with_index do |line, idx|
          if idx.zero?
            line
          else
            "#{padding(level)}#{status_padding}#{key_padding(key)}#{line}"
          end
        end.join
      end

      def check_element_visible?
        unless wait_until_true { element.visible? }
          raise Node::CheckFail, 'Element is not visible'
        end
      end

      def check_page_loaded?
        unless element.loaded?
          raise Node::CheckFail, 'Page is not loaded'
        end
      end

      def wait_until_true(&block)
        SitePrism::Waiter.wait_until_true(&block)
      rescue SitePrism::TimeoutError
        false
      end

      def check_wrapper
        yield
        @status = 'Ok'
      rescue Node::CheckFail => e
        @error = e
        @status = 'Fail'
        raise
      rescue StandardError => e
        @error = e
        @status = 'Error'
        raise
      end

      def mismatch_string(element, expectation, allowed_expectations = nil)
        element_class = element.class.ancestors.map(&:name).compact.first
        ret = "Can not check element of type #{element_class} with expectation:\n#{expectation.pretty_inspect.chomp}"
        if allowed_expectations
          return ret + ". Allowed expectations: #{allowed_expectations.join(', ')}"
        end
        ret
      end
    end
  end
end
