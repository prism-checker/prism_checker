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

    context 'when page contains array of records' do
      before do
        page.load(config: 'records')
      end

      context 'when expectation is array' do
        let(:expectation) do
          {
            records: { record: %w[Record1 Record2] }
          }
        end

        let(:expected_report) do
          <<~REPORT.strip
            {
              records: {
                record: [
                  Ok
                  Ok
                ]
              }
            }
          REPORT
        end

        it 'the result is success' do
          checker.check(page, expectation)
          expect(checker.report).to eq expected_report
        end
      end

      context 'when expectation is number of expected elements' do
        let(:expectation) do
          {
            records: { record: 2 }
          }
        end

        let(:expected_report) do
          <<~REPORT.strip
            {
              records: {
                record: Ok
              }
            }
          REPORT
        end

        it 'the result is success' do
          checker.check(page, expectation)
          expect(checker.report).to eq expected_report
        end
      end
    end
  end
end
