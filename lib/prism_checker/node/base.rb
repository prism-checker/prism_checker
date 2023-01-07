# frozen_string_literal: true

require_relative 'check_fail'
require_relative 'bad_expectation'
require_relative '../element_wrapper'
require_relative '../absence_expectation'

module PrismChecker
  module Node
    class Base
      attr_reader :name, :status, :error, :parent, :checker, :expectation

      def initialize(checker, parent, name, expectation)
        @parent = parent
        @checker = checker
        @name = name
        @expectation = expectation == :absent ? AbsenceExpectation.new(1) : expectation
        @element = nil
        @status = 'Not checked'
        @error = nil
        @timeout = Capybara.default_max_wait_time
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
        elsif parent.is_a?(Node::Hash)
          if parent.element.is_a?(Capybara::Node::Element)
            ElementWrapper.new(parent.element).send(@name)
          else
            parent.element.send(@name)
          end
        elsif parent.is_a?(Node::Array)
          parent.element[@name]
        end
      end

      def wait_until_true(&block)
        SitePrism::Waiter.wait_until_true(@timeout, &block)
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

      def check_absence
        sleep expectation.delay

        check_wrapper do
          result = wait_until_true do
            element
            false
          rescue Capybara::ElementNotFound
            true
          end

          raise Node::CheckFail, 'Element is present' unless result
        end
      end

      def check
        return check_absence if expectation.is_a?(AbsenceExpectation)

        check_wrapper do
          checkers = CheckDispatcher.checkers(element, expectation)
          value = nil
          checkers.each do |checker|
            result = wait_until_true do
              value = checker.send(:value, element)
              checker.send(:check, element, value, expectation)
            end

            raise Node::CheckFail, checker.send(:error_message, element, value, expectation) unless result
          end
        end
      end
    end
  end
end
