# frozen_string_literal: true

require_relative '../../support/pages/blog'
require 'prism_checker/checker'
require 'prism_checker/absence_expectation'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Blog.new }

  describe '.check' do
    context 'when page is valid and not contains section' do
      context 'when expected section absence' do
        before { page.load(config: 'no-posts') }

        it 'result is success' do
          expect(checker.check(page, { posts: :absent })).to eq true
        end
      end
    end

    context 'when page is invalid and contains section' do
      context 'when expected section absence' do
        before { page.load }

        let(:report) do
          <<~REPORT.strip
            {
              posts: Fail: Element is present
            }
          REPORT
        end

        let(:expectation) { { posts: :absent } }

        it 'the result is an error and a report with a description' do
          checker.check(page, expectation)
          expect(checker).to fail_with_report report
        end
      end
    end
  end
end
