# frozen_string_literal: true

# module PrismChecker
#   class ExpectationCheckers
#     def initialize(additional_expectation_checkers = [])
#       @expectation_checkers = []
#
#       build
#       additional_expectation_checkers.each do |ec|
#         add(ec[:klass], ec[:check], ec[:error_message])
#       end
#     end
#
#     def find(klass)
#       @expectation_checkers.find { |ec| klass.is_a?(ec[:class]) } || default_expectation_checker
#     end
#
#     def add(klass, check, error_message)
#       @expectation_checkers << {
#         class: klass,
#         check: check,
#         error_message: error_message
#       }
#     end
#
#     private
#
#     def build
#       @expectation_checkers = []
#
#       build_string_expectation_checker
#       build_regexp_expectation_checker
#     end
#
#     def build_string_expectation_checker
#       add(
#         String,
#         ->(expectation, value) { value.to_s.include?(expectation) },
#         ->(expectation, value) { "Expected '#{value}' to include '#{expectation}'" }
#       )
#     end
#
#     def build_regexp_expectation_checker
#       add(
#         Regexp,
#         ->(expectation, value) { value.to_s =~ expectation },
#         ->(expectation, value) { "Expected '#{value}' to match '/#{expectation.source}/'" }
#       )
#     end
#
#     def default_expectation_checker
#       {
#         check: ->(expectation, value) { value == expectation },
#         error_message: lambda do |expectation, value|
#           "Expected #{value} (#{value.class.name}) to equal #{expectation} (#{expectation.class.name})"
#         end
#       }
#     end
#   end
# end
