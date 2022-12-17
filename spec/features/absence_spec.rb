# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  let(:page) { Blog.new }
  subject(:checker) { described_class.new }

  describe '.check' do
    context 'when page is valid' do
      context 'when page contains invisible section' do
        before do
          page.load(config: 'no-posts')
        end

        it 'result is success' do
          expect(checker.check(page, {posts: :absent})).to eq true
        end
      end
    end

    context 'when page is invalid' do
      context 'when page contains visible section' do
        before do
          page.load
        end

        let(:expectation) { {posts: :absent} }

        it 'result is failure' do
          expect(checker.check(page, expectation)).to eq false
        end

        it 'report contains description' do
          checker.check(page, expectation)
          expect(checker.report).to eq <<~REPORT.strip
            {
              posts: Fail: Element is present
            }
          REPORT
        end
      end
    end
  end
end
