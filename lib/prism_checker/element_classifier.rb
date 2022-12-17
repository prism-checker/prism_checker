# frozen_string_literal: true

module PrismChecker
  class ElementClassifier
    def self.classify(element)
      return :checkbox if element_checkbox?(element)
      return :input if element_input?(element)
      return :select if element_select?(element)
      return :image if element_image?(element)
      return :element if element?(element)
      return :section if section?(element)
      return :page if page?(element)
      return :array if array?(element)

      :other
    end

    def self.page?(element)
      element.is_a?(SitePrism::Page)
    end

    def self.section?(element)
      element.is_a?(SitePrism::Section)
    end

    def self.element?(element)
      element.is_a?(Capybara::Node::Element)
    end

    def self.array?(element)
      element.is_a?(::Array)
    end

    def self.element_image?(element)
      element?(element) && element.tag_name == 'img'
    end

    def self.element_input?(element)
      element?(element) && element.tag_name == 'input'
    end

    def self.element_select?(element)
      element?(element) && element.tag_name == 'select'
    end

    def self.element_checkbox?(element)
      element_input?(element) && element['type'] == 'checkbox'
    end
  end
end
