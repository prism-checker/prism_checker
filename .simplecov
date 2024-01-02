# frozen_string_literal: true

require 'simplecov'
require "simplecov_json_formatter"

SimpleCov.start do
  add_filter '/spec'
end

SimpleCov.minimum_coverage 95
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter if ENV['SIMPLE_COV_JSON_FORMATTER']
