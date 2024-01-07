# frozen_string_literal: true

require_relative 'colorizer'

module PrismChecker
  class Config
    attr_accessor :string_comparison, :colorizer

    def initialize
      @string_comparison = :inclusion
      @colorizer = PrismChecker::Colorizer
    end
  end
end
