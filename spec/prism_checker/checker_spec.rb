# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Blog.new }

  describe '.check' do
    context 'when page contains the wrong number of sections' do
      before do
        page.load
      end

      let(:expectation) do
        {
          header: 'My Blog',
          posts: {
            post: 3,
            header: 'Posts'
          }
        }
      end

      let(:expected_report) do
        <<~REPORT.strip
          {
            header: Ok
            posts: {
              post: Fail: Wrong elements count
                          Actual: 2
                          Expected: 3
              header: Not checked
            }
          }
        REPORT
      end

      it 'the result is an error and a report with a description' do
        checker.check(page, expectation)
        expect(checker).to fail_with_report(expected_report)
      end
    end

    context 'when page contains the wrong section inside array of sections' do
      before do
        page.load
      end

      let(:expectation) do
        {
          posts: {
            post: [
              { title: 'Lorem ipsum' },
              { title: 'Ut eget justo erat' }
            ]
          }
        }
      end

      let(:expected_report) do
        <<~REPORT.strip
          {
            posts: {
              post: [
                {
                  title: Ok
                }
                {
                  title: Fail: Expected 'Vestibulum ante' to include 'Ut eget justo erat'
                }
              ]
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
