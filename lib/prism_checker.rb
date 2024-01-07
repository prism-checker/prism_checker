# frozen_string_literal: true

require 'prism_checker/checker'
require 'prism_checker/config'

module PrismChecker
  class << self
    extend Forwardable

    def_delegators :config, :string_comparison, :string_comparison=
    def_delegators :config, :colorizer, :colorizer=

    private

    def config
      @config ||= PrismChecker::Config.new
    end
  end
end
