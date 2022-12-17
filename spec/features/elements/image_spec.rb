# frozen_string_literal: true

require_relative '../../support/pages/elements'
require 'prism_checker/checker'

describe PrismChecker::Checker do
  let(:page) { Elements.new }
  subject(:checker) { described_class.new }

  describe '.check' do
    context 'when image is valid' do
      before do
        page.load
      end

      context 'when image described as string' do
        it 'result is success' do
          expect(checker.check(page, image: 'logo.png')).to eq true
        end
      end

      context 'when image described as regexp' do
        it 'result is success' do
          expect(checker.check(page, image: /logo.png/)).to eq true
        end
      end

      context 'when image described as hash' do
        it 'result is success' do
          expect(checker.check(page, image: {src: 'logo.png', 'data-foo' => 'foo'})).to eq true
        end
      end
    end

    context 'when image is invalid' do
      before do
        page.load
      end

      context 'when image described as string' do
        it 'result is failure' do
          expect(checker.check(page, image: 'wrong-logo.png')).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            image: Fail: Expected 'http://example.com/logo.png' to include 'wrong-logo.png'
          }
          REPORT

          checker.check(page, image: 'wrong-logo.png')
          expect(checker.report).to eq(expected_report)
        end
      end

      context 'when image described as regexp' do
        it 'result is failure' do
          expect(checker.check(page, image: /wrong-logo.png/)).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            image: Fail: Expected 'http://example.com/logo.png' to match '/wrong-logo.png/'
          }
          REPORT

          checker.check(page, image: /wrong-logo.png/)
          expect(checker.report).to eq(expected_report)
        end
      end

      context 'when image described as hash' do
        it 'result is failure' do
          expect(checker.check(page, image: {src: 'wrong-logo.png', 'data-foo' => 'foo'})).to eq false
        end

        it 'report contains description' do
          expected_report = <<~REPORT.strip
          {
            image: {
              src: Fail: Expected 'http://example.com/logo.png' to include 'wrong-logo.png'
              data-foo: Not checked
            }
          }
          REPORT

          checker.check(page, image: {src: 'wrong-logo.png', 'data-foo' => 'foo'})
          expect(checker.report).to eq(expected_report)
        end
      end
    end
  end
end
