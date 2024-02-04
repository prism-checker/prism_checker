# frozen_string_literal: true

require_relative 'node/hash'
require_relative 'node/array'
require_relative 'node/expectation'
require_relative 'report_builder'

module PrismChecker
  class Checker
    attr_reader :item, :root, :result

    def initialize
      @item = nil
      @expectation = nil
      @root = nil
      @result = nil
    end

    def check(item, expectation)
      prepare(item, expectation)

      walk_through do |node|
        node.check
      end

      @result = true
    rescue Node::CheckFail
      # puts report
      @result = false
      # rescue Node::BadExpectation => e
      #   # raise
      #   raise e.class, report + "\n" + e.message
    rescue StandardError => e
      # puts '---------------------'
      # puts e.class
      # puts e.message
      # pp e.backtrace
      # puts '---------------------'
      raise e.class, "#{report}\n#{e.message}"
    end

    def report
      ReportBuilder.new(@root).build
    end

    private

    def walk_through(&block)
      @root.walk_through(&block)
    end

    def build_node(expectation, parent, key)
      klass = case expectation
              when Hash then Node::Hash
              when Array then Node::Array
              else Node::Expectation
              end

      klass.new(self, parent, key, expectation)
    end

    def prepare(item, expectation)
      @item = item
      @expectation = expectation
      @root = build_node(expectation, self, :root)

      build_tree(expectation, @root)
    end

    def build_tree(expectation, parent)
      enumerator = case expectation
                   when Hash then expectation.each_key
                   when Array then expectation.each_index
                   else return
                   end

      enumerator.each do |key|
        child = parent.add_child(key, build_node(expectation[key], parent, key))
        build_tree(expectation[key], child)
      end
    end
  end
end
