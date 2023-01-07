# frozen_string_literal: true

require 'prism_checker/check_dispatcher'

describe PrismChecker::CheckDispatcher do
  subject(:dispatcher) { described_class }

  describe '#checkers' do
    context 'when element and expectation are valid' do
      it 'result is array of checkers' do
        expect(dispatcher.checkers('string', 'string')).to be_an Array
      end
    end

    context 'when element is unknown' do
      it 'dispatcher raises error' do
        expect { dispatcher.checkers(1...2, 'string') }
          .to raise_error(PrismChecker::Node::BadExpectation)
          .with_message("Don't know how to check Range")
      end
    end

    context 'when expectation is unknown' do
      it 'dispatcher raises error' do
        expect { dispatcher.checkers('string', 1...2) }
          .to raise_error(PrismChecker::Node::BadExpectation)
          .with_message("Don't know how to compare String with Range")
      end
    end
  end

  describe '#add' do
    context 'when added custom checkers for pair of some classes Foo and Bar' do
      it '@check_map contains custom checks' do
        dispatcher.add(:foo, :bar, ['checker stub'])
        check_map = dispatcher.instance_variable_get(:@check_map)
        expect(check_map[:foo][:bar]).to eq ['checker stub']
      end
    end
  end
end
