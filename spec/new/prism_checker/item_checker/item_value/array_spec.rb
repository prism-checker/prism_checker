# frozen_string_literal: true

require 'prism_checker/item_checker/item_value/array'

describe PrismChecker::ItemChecker::ItemValue::Array do
  let(:item_value) { extend described_class }

  describe '#value' do
    it 'extracts value' do
      expect(item_value.value([1, 2])).to eq '1 2'
    end
  end
end
