# frozen_string_literal: true

require_relative 'element_classifier'
require_relative 'expectation_classifier'
require_relative 'item_checker/array'
require_relative 'item_checker/element'
require_relative 'item_checker/elements'
require_relative 'item_checker/image'
require_relative 'item_checker/input'
require_relative 'item_checker/page'
require_relative 'item_checker/string'

module PrismChecker
  class CheckDispatcher
    METHODS2 = {
      string: {
        page: [PrismChecker::ItemChecker::Page::Loaded, PrismChecker::ItemChecker::Page::String2],
        section: [PrismChecker::ItemChecker::Element::Visible, PrismChecker::ItemChecker::Element::String],
        sections: [PrismChecker::ItemChecker::Elements::String],
        element: [PrismChecker::ItemChecker::Element::Visible, PrismChecker::ItemChecker::Element::String],
        elements: [PrismChecker::ItemChecker::Elements::String],
        image: [PrismChecker::ItemChecker::Image::String],
        input: [PrismChecker::ItemChecker::Input::String]
      },
      regexp: {
        page: [PrismChecker::ItemChecker::Page::Loaded, PrismChecker::ItemChecker::Page::Regexp2],
        section: [PrismChecker::ItemChecker::Element::Visible, PrismChecker::ItemChecker::Element::Regexp],
        sections: [PrismChecker::ItemChecker::Elements::Regexp],
        element: [PrismChecker::ItemChecker::Element::Visible, PrismChecker::ItemChecker::Element::Regexp],
        elements: [PrismChecker::ItemChecker::Elements::Regexp],
        image: [PrismChecker::ItemChecker::Image::Regexp],
        input: [PrismChecker::ItemChecker::Input::Regexp]
      },
      invisible: {
        section: [PrismChecker::ItemChecker::Element::Invisible],
        element: [PrismChecker::ItemChecker::Element::Invisible],
        image: [PrismChecker::ItemChecker::Element::Invisible],
        input: [PrismChecker::ItemChecker::Element::Invisible]
      },
      array: {
        sections: [PrismChecker::ItemChecker::Elements::Array],
        elements: [PrismChecker::ItemChecker::Elements::Array]
      }
    }.freeze

    METHODS = {
      page: {
        string: [ItemChecker::Page::Loaded, ItemChecker::Page::String2],
        regexp: [ItemChecker::Page::Loaded, ItemChecker::Page::Regexp2],
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
        array: [ItemChecker::Elements::Array]
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
        array: [ItemChecker::Elements::Array]
      },

      image: {
        string: [ItemChecker::Image::String],
        regexp: [ItemChecker::Image::Regexp],
        invisible: [ItemChecker::Element::Invisible]
      },

      input: {
        string: [ItemChecker::Input::String],
        regexp: [ItemChecker::Input::Regexp],
        invisible: [ItemChecker::Element::Invisible]
      },

      array: {
        string: [ItemChecker::Array::String],
        regexp: [ItemChecker::Array::Regexp]
      },

      string: {
        string: [ItemChecker::String::String],
        regexp: [ItemChecker::String::Regexp]
      }
    }.freeze

    def find_methods(element, expectation)
      puts "#{ElementClassifier.classify(element)} == #{ExpectationClassifier.classify(expectation)}"

      element_desc = METHODS[ElementClassifier.classify(element)]

      raise Node::BadExpectation, "Don't know how to compare '#{element}' (classified as #{ElementClassifier.classify(element)}) with expectation '#{expectation}'" unless element_desc

      return unless element_desc

      # raise_bad_expectation(element, expectation) unless element_desc

      expectation_methods = element_desc[ExpectationClassifier.classify(expectation)]

      # return unless expectation_methods
      raise_bad_expectation(element, expectation) unless expectation_methods

      expectation_methods
    end

    def mismatch_string(element, expectation)
      element_class = element.class.name || element.class.ancestors.map(&:name).compact.first || '<Unknown>'
      "Don't know how to compare '#{element_class}' with expectation '#{expectation}'"
    end

    def raise_bad_element(element, expectation)
      raise Node::BadExpectation, mismatch_string(element, expectation)
    end

    def raise_bad_expectation(element, expectation)
      raise Node::BadExpectation, mismatch_string(element, expectation)
    end
  end
end
