# frozen_string_literal: true

require 'prism_checker/expectation_classifier'

describe PrismChecker::ExpectationClassifier do
  subject(:classifier) { described_class }

  describe '#classify' do
    context 'when expectation is String' do
      it 'result is :string' do
        expect(classifier.classify('string')).to eq :string
      end
    end

    context 'when expectation is Regexp' do
      it 'result is :regexp' do
        expect(classifier.classify(/string/)).to eq :regexp
      end
    end

    context 'when expectation is Array' do
      it 'result is :array' do
        expect(classifier.classify([])).to eq :array
      end
    end

    context 'when expectation is Hash' do
      it 'result is :hash' do
        expect(classifier.classify({})).to eq :hash
      end
    end

    context 'when expectation is Symbol :invisible' do
      it 'result is :invisible' do
        expect(classifier.classify(:invisible)).to eq :invisible
      end
    end

    context 'when expectation is "true"' do
      it 'result is :boolean' do
        expect(classifier.classify(true)).to eq :boolean
      end
    end

    context 'when expectation is "false"' do
      it 'result is :boolean' do
        expect(classifier.classify(false)).to eq :boolean
      end
    end

    context 'when expectation is something unusual' do
      it 'result is :other' do
        expect(classifier.classify(Class)).to eq :other
      end
    end
  end

  describe '#add' do
    context 'when added custom classifier for Hash' do
      context 'when expectation is Hash' do
        it 'result is :hash' do
          classifier.add(:hash, ->(item) { item.is_a?(Hash) })
          expect(classifier.classify({})).to eq :hash
        end
      end
    end
  end
end
