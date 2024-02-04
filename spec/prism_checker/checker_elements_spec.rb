# frozen_string_literal: true

require_relative '../support/pages/elements'
require 'prism_checker'

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

      context 'when input described as :empty' do
        it 'result is success' do
          page.input.set('')
          expect(checker.check(page, input: :empty)).to eq true
        end
      end

      context 'when input described as hash' do
        it 'result is success' do
          expect(checker.check(page, input: { value: 'input value', class: 'foo' })).to eq true
        end
      end
    end

    context 'with valid textarea' do
      context 'when textarea described as string' do
        context 'when content defined as text (<textarea>textarea value</textarea>)' do
          it 'result is success' do
            expect(checker.check(page, textarea: 'textarea value')).to eq true
          end
        end

        context 'when content defined as value (via JS)' do
          it 'result is success' do
            page.textarea.set('JS value')
            expect(checker.check(page, textarea: 'JS value')).to eq true
          end
        end
      end

      context 'when textarea described as hash' do
        it 'result is success' do
          page.textarea.set('value')
          expect(checker.check(page, textarea: { text: 'textarea value', value: 'value', 'data-foo' => 'foo' })).to eq true
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

    context 'when inspected item is an correct array' do
      context 'when expectation is :empty' do
        it 'result is success' do
          expect(checker.check(page.empty_array, :empty)).to eq true
        end
      end

      context 'when expectation is an array' do
        it 'result is success' do
          checker.check(page.some_array, [1, 2, 4])
          expect(checker.check(page.some_array, [1, 2, 3])).to eq true
        end
      end
    end

    context 'when inspected item is an incorrect array' do
      context 'when expectation is :empty' do
        it 'result is failure' do
          checker.check(page.some_array, :empty)
          expect(checker).to fail_with_report('Fail: Expected to be empty')
        end
      end

      context 'when expectation is an array' do
        let(:expected_report) do
          <<~REPORT.strip
            [
              Ok
              Ok
              Fail: Expected: 4
                    Got: 3
            ]
          REPORT
        end

        it 'result is failure' do
          checker.check(page.some_array, [1, 2, 4])
          expect(checker).to fail_with_report(expected_report)
        end
      end
    end
  end
end
