# frozen_string_literal: true

require 'rspec/expectations'

module PrismChecker
  class Checker
    # RSepc differ use inspect to create diff
    def inspect
      report
    end
  end
end

class FailWithReport < RSpec::Matchers::BuiltIn::BaseMatcher
  def failure_message
    return "\nExpected result false, got #{actual.result}\n" if actual.result != false

    # "Expected report\n#{actual.report}\nto match\n#{expected}"
    'Wrong report'
  end

  def diffable?
    !actual.result
  end

  private

  def match(expected_report, checker)
    if expected_report.is_a? Regexp
      checker.result == false && checker.report =~ expected_report
    else
      checker.result == false && checker.report == expected_report
    end
  end
end

module RSpec
  module Matchers
    def fail_with_report(expected_report)
      FailWithReport.new(expected_report)
    end
  end
end
