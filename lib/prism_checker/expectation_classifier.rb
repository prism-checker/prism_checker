# frozen_string_literal: true

module PrismChecker
  class ExpectationClassifier
    def self.classify(expectation)
      return :string if expectation.is_a?(String)
      return :regexp if expectation.is_a?(Regexp)
      return :invisible if expectation == :invisible
      return :absent if expectation == :absent
      return :boolean if expectation.is_a?(TrueClass) || expectation.is_a?(FalseClass)

      :other
    end
  end
end
