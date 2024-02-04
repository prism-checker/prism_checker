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
require_relative 'item_checker/textarea'
require_relative 'item_checker/nil'
require_relative 'node/bad_expectation'

module PrismChecker
  class CheckDispatcher
    @common_element_checkers = {
      string: [ItemChecker::Element::Visible, ItemChecker::Element::String],
      empty: [ItemChecker::Element::Empty],
      regexp: [ItemChecker::Element::Visible, ItemChecker::Element::Regexp],
      hash: [ItemChecker::Element::Visible],
      visible: [ItemChecker::Element::Visible],
      invisible: [ItemChecker::Element::Invisible]
    }

    @common_elements_checkers = {
      string: [ItemChecker::Elements::String],
      empty: [ItemChecker::Elements::Empty],
      regexp: [ItemChecker::Elements::Regexp],
      array: [ItemChecker::Elements::Array],
      number: [ItemChecker::Elements::Number]
    }

    @common_input_checkers = {
      string: [ItemChecker::Element::Visible, ItemChecker::Input::String],
      empty: [ItemChecker::Element::Visible, ItemChecker::Input::Empty],
      regexp: [ItemChecker::Element::Visible, ItemChecker::Input::Regexp],
      hash: [ItemChecker::Element::Visible],
      visible: [ItemChecker::Element::Visible],
      invisible: [ItemChecker::Element::Invisible]
    }

    @check_map = {
      page: {
        string: [ItemChecker::Page::Loaded, ItemChecker::Page::String],
        regexp: [ItemChecker::Page::Loaded, ItemChecker::Page::Regexp],
        hash: [ItemChecker::Page::Loaded]
      },

      section: @common_element_checkers,
      element: @common_element_checkers,

      sections: @common_elements_checkers,
      elements: @common_elements_checkers,

      image: {
        string: [ItemChecker::Element::Visible, ItemChecker::Image::String],
        regexp: [ItemChecker::Element::Visible, ItemChecker::Image::Regexp],
        hash: [ItemChecker::Element::Visible],
        visible: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible]
      },

      input: @common_input_checkers,
      textarea: @common_input_checkers,
      select: @common_input_checkers,

      radio: {
        string: [ItemChecker::Element::Visible, ItemChecker::Input::String],
        regexp: [ItemChecker::Element::Visible, ItemChecker::Input::Regexp],
        hash: [ItemChecker::Element::Visible],
        visible: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible],
        boolean: [ItemChecker::Element::Visible, ItemChecker::Checkbox::Boolean]
      },

      checkbox: {
        hash: [ItemChecker::Element::Visible],
        visible: [ItemChecker::Element::Visible],
        invisible: [ItemChecker::Element::Invisible],
        boolean: [ItemChecker::Element::Visible, ItemChecker::Checkbox::Boolean]
      },

      array: {
        array: [ItemChecker::Array::Array],
        string: [ItemChecker::Array::String],
        empty: [ItemChecker::Array::Empty],
        regexp: [ItemChecker::Array::Regexp],
        number: [ItemChecker::Elements::Number]
      },

      boolean: {
        boolean: [ItemChecker::Any::Any]
      },

      other: {
        number: [ItemChecker::Any::Any],
        other: [ItemChecker::Any::Any]
      },

      string: {
        string: [ItemChecker::String::String],
        empty: [ItemChecker::String::Empty],
        regexp: [ItemChecker::String::Regexp]
      },

      nil: {
        string: [ItemChecker::Nil::String],
        regexp: [ItemChecker::Nil::Regexp]
      }
    }

    def self.checkers(_node, element, expectation, item_type)
      expectation_type = ExpectationClassifier.classify(expectation)

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
