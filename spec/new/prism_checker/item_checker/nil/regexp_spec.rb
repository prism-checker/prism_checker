# frozen_string_literal: true

require 'prism_checker/item_checker/nil'

describe PrismChecker::ItemChecker::Nil::Regexp do
  let(:item_checker) { described_class }

  describe '#value' do
    it 'extracts value' do
      expect(item_checker.value(nil)).to be_nil
    end
  end

  describe '#check' do
    it 'chackes value' do
      expect(item_checker.check(nil, nil, nil)).to be false
    end
  end

  describe '#error_message' do
    it 'generates error message' do
      expect(item_checker.error_message(nil, nil, /expectation/)).to eq "Expected '/expectation/', got nil"
    end
  end
end
