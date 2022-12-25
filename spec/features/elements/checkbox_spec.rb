# frozen_string_literal: true

require_relative '../../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker, skip: true do
  subject(:checker) { described_class.new }

  let(:page) { Elements.new }

  describe '.check' do
    context 'when checkbox is valid' do
      before do
        page.load
      end

      context 'when checkbox is checked and described as boolean' do
        it 'result is success' do
          expect(checker.check(page, checkbox_checked: true)).to eq true
        end
      end

      context 'when checkbox is unchecked and described as boolean' do
        it 'result is success' do
          expect(checker.check(page, checkbox_unchecked: false)).to eq true
        end
      end

      context 'when checkbox is checked and described as hash' do
        it 'result is success' do
          expect(checker.check(page, checkbox_checked: {checked: true, id: 'input-checkbox-checked'})).to eq true
        end
      end

      context 'when checkbox is unchecked and described as hash' do
        it 'result is success' do
          expect(checker.check(page, checkbox_unchecked: {checked: false, id: 'input-checkbox-unchecked'})).to eq true
        end
      end
    end

    context 'when checkbox is invalid' do
      before do
        page.load
      end

      context 'when checkbox is checked and described as boolean' do
        let(:expectation) { {checkbox_checked: false} }

        it 'result is failure' do
          expect(checker.check(page, expectation)).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
            {
              checkbox_checked: Fail: Expected to be unchecked
            }
          REPORT

          checker.check(page, expectation)
          expect(checker.report).to eq(expected_report)
        end
      end

      context 'when checkbox is checked and described as hash' do
        let(:expectation) { {checkbox_checked: {checked: false, id: 'input-checkbox-checked'}} }

        it 'result is failure' do
          expect(checker.check(page, expectation)).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
            {
              checkbox_checked: {
                checked: Fail: Expected 'true' to be 'false'
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
