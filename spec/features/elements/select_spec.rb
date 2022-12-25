# frozen_string_literal: true

require_relative '../../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker, skip: true do
  let(:page) { Elements.new }
  subject(:checker) { described_class.new }

  describe '.check' do
    context 'when select is valid' do
      before do
        page.load
      end

      context 'when select with selected option described as string' do
        it 'result is success' do
          expect(checker.check(page, select_selected: 'option2')).to eq true
        end
      end

      context 'when select without selected option described as string' do
        it 'result is success' do
          expect(checker.check(page, select_unselected: '')).to eq true
        end
      end

      context 'when checked select described as hash' do
        it 'result is success' do
          expect(checker.check(page, select_unselected: {value: '', 'data-foo'=> 'foo'})).to eq true
        end
      end
    end

    context 'when select is invalid' do
      before do
        page.load
      end

      context 'when select with selected option described as string' do
        let(:expectation) { {select_selected: 'wrong-option'} }
        it 'result is failure' do
          expect(checker.check(page, expectation)).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            select_selected: Fail: Expected 'option2' (String) to equal 'wrong-option' (String)
          }
          REPORT

          checker.check(page, expectation)
          expect(checker.report).to eq(expected_report)
        end
      end
    end
  end
end
