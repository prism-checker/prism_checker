# frozen_string_literal: true

require 'simplecov'
require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'
require 'byebug'
require 'site_prism'
require 'selenium-webdriver'
require 'webdrivers'
require 'readline'
require_relative './custom_matchers'

# Webdrivers::Chromedriver.required_version = '114.0.5735.16'

Capybara.default_max_wait_time = 5

Webdrivers::Chromedriver.required_version = ENV['CHROMEDRIVER_VERSION'] if ENV['CHROMEDRIVER_VERSION']

options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
  opts.binary = ENV['BROWSER_BINARY'] if ENV['BROWSER_BINARY']
  opts.add_argument('--no-sandbox')
  opts.headless! unless ENV['DISABLE_HEADLESS_TESTS']
  opts.add_argument('--disable-dev-shm-usage')
  opts.add_argument('--disable-gpu')
end

Capybara.register_driver :prism_checker do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [options])
end

Capybara.configure do |config|
  config.default_driver = :prism_checker
  config.default_max_wait_time = 1
  config.app_host = "file://#{File.dirname(__FILE__)}/../test_site"
  config.ignore_hidden_elements = false
end

def wait_enter
  puts '--------- Press enter to continue ---------'
  Readline.readline
  puts 'continue...'
end
