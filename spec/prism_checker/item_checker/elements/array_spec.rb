# frozen_string_literal: true

require 'prism_checker/item_checker/elements'

describe PrismChecker::ItemChecker::Elements::Array do
  let(:item_checker) { described_class }

  describe '#value' do
    it 'extracts value' do
      expect(item_checker.value([1, 2])).to eq [1, 2]
    end
  end

  describe '#check' do
    it 'chackes value' do
      expect(item_checker.check([1, 2], nil, [1, 2])).to be true
    end
  end

  describe '#error_message' do
    it 'generates error message' do
      expect(item_checker.error_message([1], nil, [1, 2])).to eq "Wrong elements count\nActual: 1\nExpected: 2"
    end
  end
end
