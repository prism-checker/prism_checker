# frozen_string_literal: true

require 'prism_checker'
require_relative '../support/pages/blog'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Blog.new }

  describe '.report' do
    before { page.load }

    let(:expectation) do
      {
        posts: {
          post: [
            { post_title: 'Lorem ipsum' },
            { post_title: 'Vestibulum ante' }
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
                post_title: Ok
              }
              {
                post_title: Ok
              }
            ]
          }
        }
      REPORT
    end

    context 'when element and expectation are valid' do
      it 'result is array of checkers' do
        checker.check(page, expectation)
        expect(checker.report).to eq expected_report
      end
    end
  end
end
