# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Blog.new }

  describe '.check' do
    context 'when page contains invisible section' do
      before do
        page.load(config: 'invisible-posts')
      end

      context 'when expected invisible section' do
        it 'result is success' do
          expect(checker.check(page, { posts: :invisible })).to eq true
        end
      end

      context 'when expected visible section' do
        let(:expectation) { { posts: {} } }
        let(:expected_report) do
          <<~REPORT.strip
            {
              posts: Fail: Element is not visible
            }
          REPORT
        end

        it 'the result is an error and a report with a description' do
          checker.check(page, expectation)
          expect(checker).to fail_with_report(expected_report)
        end
      end
    end

    context 'when page contains section' do
      before do
        page.load
      end

      context 'when expected invisible section' do
        let(:expectation) { { posts: :invisible } }
        let(:expected_report) do
          <<~REPORT.strip
            {
              posts: Fail: Element is visible
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
end
