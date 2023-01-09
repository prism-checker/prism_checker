# frozen_string_literal: true

require 'prism_checker/item_checker/item_value/page'
require_relative '../../../support/pages/simple_page'

describe PrismChecker::ItemChecker::ItemValue::Page do
  let(:item_value) { extend described_class }
  let(:page) { SimplePage.new }

  before { page.load }

  describe '#value' do
    it 'extracts value' do
      expect(item_value.value(page)).to eq 'Body'
    end
  end
end
