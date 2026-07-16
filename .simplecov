# frozen_string_literal: true

require 'simplecov_json_formatter'

SimpleCov.configure do
  skip '/spec'
end

SimpleCov.minimum_coverage 95
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter if ENV['SIMPLE_COV_JSON_FORMATTER']
