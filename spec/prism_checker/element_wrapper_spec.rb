# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker/element_wrapper'

describe PrismChecker::ElementWrapper do
  subject(:wrapper) { described_class.new(nil) }

  describe '.respond_to_missing?' do
    it 'returns true' do
      expect(wrapper.respond_to?(:bar)).to eq true
    end
  end
end
