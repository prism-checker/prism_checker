# frozen_string_literal: true

require_relative '../../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Elements.new }
  before { page.load }

  describe '.check' do
    context 'with valid image' do
      context 'when image described as string' do
        it 'result is success' do
          expect(checker.check(page, image: 'logo.png')).to eq true
        end
      end

      context 'when image described as hash' do
        it 'result is success' do
          expect(checker.check(page, image: { src: 'http://example.com/logo.png', 'data-foo' => 'foo' })).to eq true
        end
      end
    end

    context 'with valid input' do
      context 'when input described as string' do
        it 'result is success' do
          expect(checker.check(page, input: 'input value')).to eq true
        end
      end

      context 'when input described as hash' do
        it 'result is success' do
          expect(checker.check(page, input: { value: 'input value', id: 'input' })).to eq true
        end
      end
    end

    context 'with valid textarea' do
      context 'when textarea described as string' do
        it 'result is success' do
          expect(checker.check(page, textarea: 'textarea value')).to eq true
        end
      end

      context 'when textarea described as hash' do
        it 'result is success' do
          expect(checker.check(page, textarea: { text: 'textarea value', value: 'textarea value', 'data-foo' => 'foo' })).to eq true
        end
      end
    end

    context 'with valid checkbox' do
      context 'when checkbox described as boolean' do
        it 'result is success' do
          expect(checker.check(page, checkbox_checked: true)).to eq true
        end
      end

      context 'when checkbox described as hash' do
        it 'result is success' do
          expect(checker.check(page, checkbox_checked: { checked: true, value: '1', id: 'input-checkbox-checked' })).to eq true
        end
      end
    end

    context 'with valid select' do
      context 'when select has selected option' do
        context 'when select described as string' do
          it 'result is success' do
            expect(checker.check(page, select_selected: 'option2')).to eq true
          end
        end
      end

      context 'when select described as hash' do
        it 'result is success' do
          expect(checker.check(page, select: { value: 'option2', id: 'select-selected' })).to eq true
        end
      end
    end

    context 'with valid radio button' do
      context 'when button selected' do
        context 'when button described as string' do
          it 'result is success' do
            expect(checker.check(page, radio_selected: true)).to eq true
          end
        end
      end

      context 'when select described as hash' do
        it 'result is success' do
          expect(checker.check(page, radio_selected: { value: '1', name: 'radio', checked: true })).to eq true
        end
      end
    end
  end
end
