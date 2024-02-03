# frozen_string_literal: true

require 'site_prism'
require 'capybara'

module PrismChecker
  class ItemClassifier
    @elements_map = [
      %i[checkbox element_checkbox?],
      %i[radio element_radio?],
      %i[input element_input?],
      %i[textarea element_textarea?],
      %i[select element_select?],
      %i[image element_image?],
      %i[element element?],
      %i[elements elements?],
      %i[section section?],
      %i[sections sections?],
      %i[page page?],
      %i[array array?],
      %i[string string?],
      %i[boolean boolean?],
      %i[nil element_nil?]
    ]

    def self.classify(element)
      @elements_map.each do |data|
        type = data[0]
        probe = data[1]
        if probe.is_a? Symbol
          return type if send(probe, element)
        elsif probe.call(element)
          return type
        end
      end

      :other
    end

    def self.page?(element)
      element.is_a?(SitePrism::Page)
    end

    def self.section?(element)
      element.is_a?(SitePrism::Section)
    end

    def self.sections?(element)
      element.all?(SitePrism::Section)
    rescue StandardError
      false
    end

    def self.element?(element)
      element.is_a?(Capybara::Node::Element)
    end

    def self.elements?(element)
      element.all?(Capybara::Node::Element)
    rescue StandardError
      false
    end

    def self.array?(element)
      element.is_a?(::Array)
    end

    def self.string?(element)
      element.is_a?(::String)
    end

    def self.element_image?(element)
      return false unless element?(element)
      return false unless element.tag_name == 'img'

      true
    end

    def self.element_input?(element)
      return false unless element?(element)
      return false unless element.tag_name == 'input'

      true
    end

    def self.element_textarea?(element)
      return false unless element?(element)
      return false unless element.tag_name == 'textarea'

      true
    end

    def self.element_select?(element)
      return false unless element?(element)
      return false unless element.tag_name == 'select'

      true
    end

    def self.element_checkbox?(element)
      return false unless element?(element)
      return false unless element['type'] == 'checkbox'

      true
    end

    def self.element_radio?(element)
      return false unless element?(element)
      return false unless element['type'] == 'radio'

      true
    end

    def self.boolean?(element)
      return true if element.is_a?(TrueClass)
      return true if element.is_a?(FalseClass)

      false
    end

    def self.element_nil?(element)
      element.nil?
    end

    def self.add(type, probe, position = 0)
      @elements_map.insert(position, [type, probe])
    end
  end
end
