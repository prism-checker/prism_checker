# frozen_string_literal: true

require 'prism_checker/item_checker/item_value/element'
require_relative '../../../../support/pages/elements'

describe PrismChecker::ItemChecker::ItemValue::Element do
  let(:item_value) { extend described_class }
  let(:page) { Elements.new }

  before { page.load }

  describe '#value' do
    it 'extracts value' do
      expect(item_value.value(page.header)).to eq 'Elements'
    end
  end
end
