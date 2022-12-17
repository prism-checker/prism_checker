# frozen_string_literal: true

require 'simplecov'

# SimpleCov.start
SimpleCov.start do
  add_filter '/spec'
end

SimpleCov.minimum_coverage 99
