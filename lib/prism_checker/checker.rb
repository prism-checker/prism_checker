# frozen_string_literal: true

# require 'colorize'
require_relative 'node/base'
require_relative 'node/hash'
require_relative 'node/array'
require_relative 'node/expectation'
require_relative 'node/bad_expectation'
require_relative 'colorizer'
# require_relative 'expectation_checkers'
require_relative 'report_builder'
require_relative 'item_classifier'
require_relative 'expectation_classifier'

module PrismChecker
  class Checker
    attr_reader :item, :root, :colorizer, :result

    def initialize(colorizer: PrismChecker::Colorizer)
      @item = nil
      @expectation = nil
      @root = nil
      @colorizer = colorizer
      @result = nil
    end

    def check(item, expectation)
      prepare(item, expectation)

      walk_through do |node|
        node.check
      end

      @result = true
    rescue Node::CheckFail
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
      raise e.class, report + "\n" + e.message
    end

    def report
      ReportBuilder.new(@root, @colorizer).build
    end

    # def print_tree(item, expectation)
    #   # prepare(item, expectation)
    #   @root.walk_through do |node, level|
    #     padding = '  ' * level
    #     puts "#{padding}#{node.name}"
    #   end
    # end

    private

    def walk_through(&block)
      @root.walk_through(&block)
    end

    def build_node(expectation, parent, key)
      case expectation
      when Hash
        Node::Hash.new(self, parent, key, expectation)
      when Array
        Node::Array.new(self, parent, key, expectation)
      else
        Node::Expectation.new(self, parent, key, expectation)
      end
    end

    def prepare(item, expectation)
      @item = item
      @expectation = expectation
      @root = build_node(expectation, self, :root)

      build_tree(expectation, @root)
    end

    def build_tree(expectation, parent)
      if expectation.is_a? Hash
        expectation.each_key do |key|
          child = parent.add_child(key, build_node(expectation[key], parent, key))
          build_tree(expectation[key], child)
        end
      elsif expectation.is_a? Array
        expectation.each_index do |idx|
          child = parent.add_child(idx, build_node(expectation[idx], parent, idx))
          build_tree(expectation[idx], child)
        end
      end
    end
  end
end
