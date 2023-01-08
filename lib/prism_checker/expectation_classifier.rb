# frozen_string_literal: true

module PrismChecker
  class ExpectationClassifier
    @expectations_map = [
      %i[invisible invisible?],
      %i[string string?],
      %i[regexp regexp?],
      %i[array array?],
      %i[hash hash?],
      %i[boolean boolean?],
      %i[number number?]
    ]

    def self.classify(expectation)

      @expectations_map.each do |data|
        type = data[0]
        probe = data[1]
        if probe.is_a? Symbol
          return type if send(probe, expectation)
        elsif probe.call(expectation)
          return type
        end
      end

      :other
    end

    def self.invisible?(expectation)
      expectation == :invisible
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

    def self.add(type, probe, position = 0)
      @expectations_map.insert(position, [type, probe])
    end
  end
end
