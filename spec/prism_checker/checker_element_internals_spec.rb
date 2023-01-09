# frozen_string_literal: true

require_relative '../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Elements.new }

  describe '.check' do
    context 'when expectation for element is defined as hash and element is not valid' do
      before do
        page.load
      end

      let(:expectation) do
        {
          header: {
            text: 'Elements',
            class: 'header',
            'data-foo' => 'foo',
            'data-bar' => 'bar'
          }
        }
      end

      let(:expected_report) do
        <<~REPORT.strip
          {
            header: {
              text: Ok
              class: Ok
              data-foo: Ok
              data-bar: Fail: Expected 'bar', got nil
            }
          }
        REPORT
      end

      it 'the result is an error and a report with a description' do
        checker.check(page, expectation)
        expect(checker).to fail_with_report(expected_report)
      end
    end
  end
end
