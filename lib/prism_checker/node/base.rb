# frozen_string_literal: true

require_relative 'check_fail'
require_relative 'bad_expectation'
require_relative '../element_wrapper'
require_relative '../absence_expectation'
require_relative '../item_classifier'

module PrismChecker
  module Node
    class Base
      attr_reader :name, :status, :error, :parent, :checker, :expectation

      def initialize(checker, parent, name, expectation)
        @parent = parent
        @checker = checker
        @name = name
        @expectation = expectation == :absent ? AbsenceExpectation.new(1) : expectation # TODO: expectation time!
        @element = nil
        @status = 'Not checked'
        @error = nil
        @timeout = Capybara.default_max_wait_time
        @type = nil
        @checked_element = nil
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
        return @checked_element if @checked_element

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

      def wait_until_true(timeout = @timeout, &block)
        SitePrism::Waiter.wait_until_true(timeout, &block)
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
          result = wait_until_true(0.1) do
            parent.element.public_send("has_no_#{name}?")
          #   element
          #   false
          # rescue Capybara::ElementNotFound
          #   true
          end

          raise Node::CheckFail, 'Element is present' unless result
        end
      end

      def path
        result = []
        p = self

        while p.is_a? Base
          result << p.name
          p = p.parent
        end

        result.reverse
      end

      def type(element)
        @type ||= ItemClassifier.classify(element)
      end

      def check
        return check_absence if expectation.is_a?(AbsenceExpectation)

        check_wrapper do
          element = self.element
          element_type = type(element)
          checkers = CheckDispatcher.checkers(self, element, expectation, element_type)
          value = nil
          checkers.each do |checker|
            result = wait_until_true do
              element = self.element if element.is_a? ::Array

              value = checker.send(:value, element)
              checker.send(:check, element, value, expectation)
            end

            raise Node::CheckFail, checker.send(:error_message, element, value, expectation) unless result
          end

          @checked_element = element
        end
      end
    end
  end
end
