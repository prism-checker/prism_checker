# frozen_string_literal: true

require 'prism_checker/item_checker/item_check/string'

describe PrismChecker::ItemChecker::ItemCheck::String do
  let(:checker) { extend described_class }

  describe '#check' do
    context 'when checked value is correct' do
      it 'result is true' do
        expect(checker.check(nil, 'value', 'value')).to be_truthy
      end
    end

    context 'when checked value is incorrect' do
      it 'result is false' do
        expect(checker.check(nil, 'wrong', 'value')).to be_falsey
      end
    end
  end

  describe '#error_message' do
    it 'returns error message' do
      expect(checker.error_message(nil, 'wrong', 'value')).to eq "Expected 'wrong' to include 'value'"
    end
  end
end
