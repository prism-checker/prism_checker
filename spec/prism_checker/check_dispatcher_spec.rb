# frozen_string_literal: true

require 'prism_checker/check_dispatcher'

describe PrismChecker::CheckDispatcher do
  subject(:dispatcher) { described_class }

  describe '#checkers' do
    context 'when element and expectation are valid' do
      it 'result is array of checkers' do
        expect(dispatcher.checkers(nil, 'string', 'string', :input)).to be_an Array
      end
    end

    context 'when element is unknown' do
      it 'dispatcher raises error' do
        expect { dispatcher.checkers(nil, 1...2, 'string', :other) }
          .to raise_error(PrismChecker::Node::BadExpectation)
          .with_message("Don't know how to compare Range with String")
      end
    end

    context 'when expectation is unknown' do
      it 'dispatcher raises error' do
        expect { dispatcher.checkers(nil, 'string', 1...2, :string) }
          .to raise_error(PrismChecker::Node::BadExpectation)
          .with_message("Don't know how to compare String with Range")
      end
    end
  end

  describe '#raise_bad_element' do
    it 'raises error' do
      expect { dispatcher.send(:raise_bad_element, 1..2) }
        .to raise_error(PrismChecker::Node::BadExpectation)
        .with_message("Don't know how to check Range")
    end
  end
end
