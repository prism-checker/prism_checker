# frozen_string_literal: true

module PrismChecker
  class ExpectationClassifier
    def self.classify(expectation)
      # return :invisible if expectation == :invisible
      #
      # case expectation
      # when String then :string
      # when Regexp then :regexp
      # when Array then :array
      # when Hash then :hash
      # when TrueClass, FalseClass then :boolean
      # when AbsenceExpectation then :absent
      # else
      #   :other
      # end

      return :string if expectation.is_a?(String)
      return :regexp if expectation.is_a?(Regexp)
      return :array if expectation.is_a?(Array)
      return :hash if expectation.is_a?(Hash)
      return :absent if expectation.is_a?(AbsenceExpectation)
      return :boolean if expectation.is_a?(TrueClass) || expectation.is_a?(FalseClass)

      :other
    end
  end
end
