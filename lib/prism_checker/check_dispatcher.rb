# frozen_string_literal: true

require_relative 'item_classifier'
require_relative 'expectation_classifier'
require_relative 'item_checker/array'
require_relative 'item_checker/element'
require_relative 'item_checker/elements'
require_relative 'item_checker/image'
require_relative 'item_checker/input'
require_relative 'item_checker/checkbox'
require_relative 'item_checker/any'
require_relative 'item_checker/page'
require_relative 'item_checker/string'
require_relative 'item_checker/nil'
require_relative 'node/bad_expectation'

module PrismChecker
  class CheckDispatcher
    @check_map = {
      page: {
        string: [ItemChecker::Page::Loaded, ItemChecker::Page::String],
        regexp: [ItemChecker::Page::Loaded, ItemChecker::Page::Regexp],
        hash: [ItemChecker::Page::Loaded]
      },

      section: {
        string: [ItemChecker::Element::Visible, ItemChecker::Element::String],
        regexp: [ItemChecker::Element::Visible, ItemChecker::Element::Regexp],
        hash: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible]
      },

      sections: {
        string: [ItemChecker::Elements::String],
        regexp: [ItemChecker::Elements::Regexp],
        array: [ItemChecker::Elements::Array],
        number: [ItemChecker::Elements::Number]
      },

      element: {
        string: [ItemChecker::Element::Visible, ItemChecker::Element::String],
        regexp: [ItemChecker::Element::Visible, ItemChecker::Element::Regexp],
        hash: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible]
      },

      elements: {
        string: [ItemChecker::Elements::String],
        regexp: [ItemChecker::Elements::Regexp],
        array: [ItemChecker::Elements::Array],
        number: [ItemChecker::Elements::Number]
      },

      image: {
        string: [ItemChecker::Image::String],
        regexp: [ItemChecker::Image::Regexp],
        hash: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible]
      },

      input: {
        string: [ItemChecker::Input::String],
        regexp: [ItemChecker::Input::Regexp],
        hash: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible]
      },

      select: {
        string: [ItemChecker::Input::String],
        regexp: [ItemChecker::Input::Regexp],
        hash: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible]
      },

      checkbox: {
        hash: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible],
        boolean: [ItemChecker::Checkbox::Boolean]
      },

      radio: {
        hash: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible],
        boolean: [ItemChecker::Checkbox::Boolean]
      },

      array: {
        string: [ItemChecker::Array::String],
        regexp: [ItemChecker::Array::Regexp],
        number: [ItemChecker::Elements::Number]
      },

      boolean: {
        boolean: [ItemChecker::Any::Any]
      },

      number: {
        number: [ItemChecker::Any::Any]
      },

      string: {
        string: [ItemChecker::Any::Any],
        regexp: [ItemChecker::String::Regexp]
      },

      nil: {
        string: [ItemChecker::Nil::String],
        regexp: [ItemChecker::Nil::Regexp]
      }
    }

    def self.checkers(element, expectation)
      item_type = ItemClassifier.classify(element)
      expectation_type = ExpectationClassifier.classify(expectation)
      puts "#{item_type} --> #{expectation_type}"

      element_expectations = @check_map[item_type]

      raise_bad_element(element) unless element_expectations

      checkers = element_expectations[expectation_type]

      raise_bad_expectation(element, expectation) unless checkers

      checkers
    end

    def self.raise_bad_element(element)
      error = "Don't know how to check #{element.class.name}"
      raise Node::BadExpectation, error
    end

    def self.raise_bad_expectation(element, expectation)
      element_class = element.class.name || element.class.ancestors.map(&:name).compact.first || '<Unknown>'
      error = "Don't know how to compare #{element_class} with #{expectation.class.name}"
      raise Node::BadExpectation, error
    end

    def self.add(element_type, check_type, checks)
      @check_map[element_type] ||= {}
      @check_map[element_type][check_type] = checks
    end
  end
end
