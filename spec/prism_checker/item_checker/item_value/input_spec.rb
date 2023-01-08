# frozen_string_literal: true

require 'prism_checker/item_checker/item_value/input'
require_relative '../../../../support/pages/elements'

describe PrismChecker::ItemChecker::ItemValue::Input do
  let(:item_value) { extend described_class }
  let(:page) { Elements.new }

  before { page.load }

  describe '#value' do
    it 'extracts value' do
      expect(item_value.value(page.input)).to eq 'input value'
    end
  end
end
