# frozen_string_literal: true

require 'prism_checker/item_checker/item_value/image'
require_relative '../../../../support/pages/elements'

describe PrismChecker::ItemChecker::ItemValue::Image do
  let(:item_value) { extend described_class }
  let(:page) { Elements.new }

  before { page.load }

  describe '#value' do
    it 'extracts value' do
      expect(item_value.value(page.image)).to eq 'http://example.com/logo.png'
    end
  end
end
