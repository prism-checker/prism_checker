# frozen_string_literal: true

require 'prism_checker'

describe PrismChecker::Node::Base do
  describe '#path' do
    it 'returns node path' do
      checker = PrismChecker::Checker.new
      checker.send(:prepare, nil, { a: { b: 'foo' } })
      node = checker.root.children[:a].children[:b]

      expect(node.path).to eq %i[root a b]
    end
  end
end
