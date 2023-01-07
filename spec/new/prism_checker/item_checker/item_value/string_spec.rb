# frozen_string_literal: true

require 'prism_checker/item_checker/item_value/string'

describe PrismChecker::ItemChecker::ItemValue::String do
  let(:item_value) { extend described_class }

  describe '#value' do
    it 'extracts value' do
      expect(item_value.value('text')).to eq 'text'
    end
  end
end
