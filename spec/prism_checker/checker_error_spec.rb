# frozen_string_literal: true

require_relative '../support/pages/blog'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  subject(:checker) { described_class.new }

  let(:page) { Blog.new }

  let(:expectation) do
    {
      header: 'My Blog',
      posts: {
        header: 'Posts'
      }
    }
  end

  let(:expected_report) do
    <<~REPORT.strip
      {
        header: Ok
        posts: Error: Unable to find css ".posts-holder"
      }
      Unable to find css ".posts-holder"
    REPORT
  end

  before { page.load(config: 'no-posts') }

  describe '.check' do
    context 'when element not found' do
      it 'raises error with report as message' do
        expect { checker.check(page, expectation) }.to raise_error(Capybara::ElementNotFound).with_message(Regexp.new(expected_report))
      end
    end
  end
end
