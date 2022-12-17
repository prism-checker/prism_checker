# frozen_string_literal: true

require_relative '../../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  let(:page) { Elements.new }
  subject(:checker) { described_class.new }

  describe '.check' do
    context 'when textarea is valid' do
      before do
        page.load
      end

      context 'when textarea described as string' do
        it 'result is success' do
          expect(checker.check(page, textarea: 'textarea value')).to eq true
        end
      end
    end

    context 'when textarea is invalid' do
      before do
        page.load
      end

      context 'when textarea described as string' do
        it 'result is failure' do
          expect(checker.check(page, textarea: 'wrong textarea')).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            textarea: Fail: Expected 'textarea value' to include 'wrong textarea'
          }
          REPORT

          checker.check(page, textarea: 'wrong textarea')
          expect(checker.report).to eq(expected_report)
        end
      end


      context 'when checked checkbox described as hash' do
        let(:expectation) { {textarea: {value: 'wrong text'}} }
        it 'result is failure' do
          expect(checker.check(page, expectation)).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            textarea: {
              value: Fail: Expected 'textarea value' to include 'wrong text'
            }
          }
          REPORT

          checker.check(page, expectation)
          expect(checker.report).to eq(expected_report)
        end
      end
    end
  end
end
