# frozen_string_literal: true

require 'simplecov'
require "simplecov_json_formatter"

SimpleCov.start do
  add_filter '/spec'
end

SimpleCov.minimum_coverage 99
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
