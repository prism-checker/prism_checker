# frozen_string_literal: true

module PrismChecker
  class ExpectationClassifier
    EXPECTATIONS_MAP = [
      %i[invisible invisible?],
      %i[visible visible?],
      %i[empty empty?],
      %i[string string?],
      %i[regexp regexp?],
      %i[array array?],
      %i[hash hash?],
      %i[boolean boolean?],
      %i[number number?]
    ].freeze

    def self.classify(expectation)
      EXPECTATIONS_MAP.each do |data|
        type, probe = data
        return type if send(probe, expectation)
      end

      :other
    end

    def self.invisible?(expectation)
      expectation == :invisible
    end

    def self.visible?(expectation)
      expectation == :visible
    end

    def self.empty?(expectation)
      expectation == :empty
    end

    def self.string?(expectation)
      expectation.is_a?(String)
    end

    def self.regexp?(expectation)
      expectation.is_a?(Regexp)
    end

    def self.array?(expectation)
      expectation.is_a?(Array)
    end

    def self.hash?(expectation)
      expectation.is_a?(Hash)
    end

    def self.boolean?(expectation)
      expectation.is_a?(TrueClass) || expectation.is_a?(FalseClass)
    end

    def self.number?(expectation)
      expectation.is_a?(Integer)
    end
  end
end
