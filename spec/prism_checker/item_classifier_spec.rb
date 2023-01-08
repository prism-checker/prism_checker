# frozen_string_literal: true

require_relative '../../support/pages/elements'
require_relative '../../support/pages/sections'
require 'prism_checker/item_classifier'

describe PrismChecker::ItemClassifier do
  subject(:classifier) { described_class }

  describe '#classify' do
    context 'when item is Capybara::Node::Element' do
      let(:page) { Elements.new }

      before { page.load }

      context 'when tag <h1>' do
        it 'result is :element' do
          expect(classifier.classify(page.header)).to eq :element
        end
      end

      context 'when tag <img>' do
        it 'result is :image' do
          expect(classifier.classify(page.image)).to eq :image
        end
      end

      context 'when tag <input>' do
        it 'result is :input' do
          expect(classifier.classify(page.input)).to eq :input
        end
      end

      context 'when tag <input type="button">' do
        it 'result is :input' do
          expect(classifier.classify(page.input_button)).to eq :input
        end
      end

      context 'when tag <input type="checkbox">' do
        it 'result is :checkbox' do
          expect(classifier.classify(page.checkbox)).to eq :checkbox
        end
      end

      context 'when tag <select>' do
        it 'result is :select' do
          expect(classifier.classify(page.select)).to eq :select
        end
      end
    end

    context 'when item is elements (array of Capybara::Node::Element)' do
      let(:page) { Elements.new }

      before { page.load }

      it 'result is :elements' do
        expect(classifier.classify(page.inputs)).to eq :elements
      end
    end

    context 'when item is section (SitePrism::Section)' do
      let(:page) { Sections.new }

      before { page.load }

      it 'result is :section' do
        expect(classifier.classify(page.header)).to eq :section
      end
    end

    context 'when item is sections (array of SitePrism::Section)' do
      let(:page) { Sections.new }

      before { page.load }

      it 'result is :sections' do
        expect(classifier.classify(page.items)).to eq :sections
      end
    end

    context 'when item is page (array of SitePrism::Page)' do
      let(:page) { Sections.new }

      before { page.load }

      it 'result is :page' do
        expect(classifier.classify(page)).to eq :page
      end
    end

    context 'when item is String' do
      it 'result is :string' do
        expect(classifier.classify('string')).to eq :string
      end
    end

    context 'when item is Array' do
      it 'result is :array' do
        expect(classifier.classify([1, 2])).to eq :array
      end
    end

    context 'when item is "true"' do
      it 'result is :boolean' do
        expect(classifier.classify(true)).to eq :boolean
      end
    end

    context 'when item is "false"' do
      it 'result is :boolean' do
        expect(classifier.classify(false)).to eq :boolean
      end
    end

    context 'when item is something unusual' do
      it 'result is :other' do
        expect(classifier.classify(Class)).to eq :other
      end
    end
  end

  describe '#add' do
    context 'when added custom classifier for Hash' do
      context 'when item is Hash' do
        it 'result is :hash' do
          classifier.add(:hash, ->(item) { item.is_a?(Hash) })
          expect(classifier.classify({})).to eq :hash
        end
      end
    end
  end
end
