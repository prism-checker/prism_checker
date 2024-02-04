# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker/element_wrapper'

describe PrismChecker::ElementWrapper do
  subject(:wrapper) { described_class.new({}) }

  describe '.respond_to_missing?' do
    it 'returns true' do
      expect(wrapper.respond_to?(:bar)).to eq true
    end
  end

  describe '.method_missing' do
    it 'raises error on unknown attribute' do
      expect { wrapper.method_missing(:bar) }.to raise_error(NoMethodError)
    end
  end
end
