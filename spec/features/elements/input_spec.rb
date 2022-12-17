# frozen_string_literal: true

require_relative '../../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  let(:page) { Elements.new }
  subject(:checker) { described_class.new }

  describe '.check' do
    context 'when input is valid' do
      before do
        page.load
      end

      context 'when input described as string' do
        it 'result is success' do
          expect(checker.check(page, input: 'input value')).to eq true
        end
      end

      context 'when checked checkbox described as boolean' do
        it 'result is success' do
          expect(checker.check(page, checkbox_checked: true)).to eq true
        end
      end

      context 'when unchecked checkbox described as boolean' do
        it 'result is success' do
          expect(checker.check(page, checkbox_unchecked: false)).to eq true
        end
      end

      context 'when checked checkbox described as hash' do
        it 'result is success' do
          expect(checker.check(page, checkbox_checked: {checked: true, id: 'input-checkbox-checked'})).to eq true
        end
      end

      context 'when unchecked checkbox described as hash' do
        it 'result is success' do
          expect(checker.check(page, checkbox_unchecked: {checked: false, id: 'input-checkbox-unchecked'})).to eq true
        end
      end
    end

    context 'when input is invalid' do
      before do
        page.load
      end

      context 'when input described as string' do
        it 'result is failure' do
          expect(checker.check(page, input: 'wrong input')).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            input: Fail: Expected 'input value' to include 'wrong input'
          }
          REPORT

          checker.check(page, input: 'wrong input')
          expect(checker.report).to eq(expected_report)
        end
      end

      context 'when checked checkbox described as boolean' do
        let(:expectation) { {checkbox_checked: false} }
        it 'result is failure' do
          expect(checker.check(page, expectation)).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            checkbox_checked: Fail: Expected true (TrueClass) to equal false (FalseClass)
          }
          REPORT

          checker.check(page, expectation)
          expect(checker.report).to eq(expected_report)
        end
      end

      context 'when checked checkbox described as hash' do
        let(:expectation) { {checkbox_checked: {checked: false, id: 'input-checkbox-checked'}} }
        it 'result is failure' do
          expect(checker.check(page, expectation)).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            checkbox_checked: {
              checked: Fail: Expected true (TrueClass) to equal false (FalseClass)
              id: Not checked
            }
          }
          REPORT

          checker.check(page, expectation)
          expect(checker.report).to eq(expected_report)
        end
      end

      # context 'when checked checkbox described as boolean' do
      #   it 'result is success' do
      #     expect(checker.check(page, checkbox_checked: true)).to eq true
      #   end
      # end
      #
      # context 'when unchecked checkbox described as boolean' do
      #   it 'result is success' do
      #     expect(checker.check(page, checkbox_unchecked: false)).to eq true
      #   end
      # end
      #
      # context 'when checked checkbox described as hash' do
      #   it 'result is success' do
      #     expect(checker.check(page, checkbox_checked: {checked: true, id: 'input-checkbox-checked'})).to eq true
      #   end
      # end
      #
      # context 'when unchecked checkbox described as hash' do
      #   it 'result is success' do
      #     expect(checker.check(page, checkbox_unchecked: {checked: false, id: 'input-checkbox-unchecked'})).to eq true
      #   end
      # end
    end
  end
end
