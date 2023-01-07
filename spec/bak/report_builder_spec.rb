# frozen_string_literal: true

require 'prism_checker/checker'
require 'prism_checker/node/base'
require 'prism_checker/report_builder'
require 'prism_checker/colorizer'

describe PrismChecker::ReportBuilder do
  subject(:builder) { described_class.new(checker.root, PrismChecker::Colorizer) }

  let(:checker) { PrismChecker::Checker.new }

  describe '.build' do
    context 'when element and expectation are valid' do
      let(:expected_report) do
        <<~REPORT.strip
          {
            foo: {
              bar: [
                Ok
                Ok
              ]
            }
            baz: Ok
          }
        REPORT
      end

      it 'result is array of checkers' do
        allow_any_instance_of(PrismChecker::Node::Base).to receive(:status).and_return('Ok')
        allow_any_instance_of(PrismChecker::Node::Base).to receive(:success?).and_return(true)
        allow_any_instance_of(PrismChecker::Node::Base).to receive(:failure?).and_return(false)


        checker.send(:prepare, nil, { foo: { bar: [1, 2] }, baz: 'baz' })
        expect(builder.build).to eq expected_report
      end
    end
  end
end
