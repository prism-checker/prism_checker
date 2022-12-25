# frozen_string_literal: true

require_relative '../../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Elements.new }

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
    end
  end
end
