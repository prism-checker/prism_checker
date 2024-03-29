# frozen_string_literal: true

require_relative '../support/pages/page_not_loaded'
require 'prism_checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { PageNotLoaded.new }

  describe '.check' do
    context 'when page is not loaded' do
      let(:expectation) { {} }
      let(:expected_report) { 'Fail: Page is not loaded' }

      it 'the result is an error and a report with a description' do
        checker.check(page, expectation)
        expect(checker).to fail_with_report(expected_report)
      end
    end
  end
end
