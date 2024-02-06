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
require 'dotenv/load'

require_relative './custom_matchers'

Capybara.default_max_wait_time = 5

browser = ENV.fetch('BROWSER', 'chrome').to_sym

options = if browser == :chrome
            Webdrivers::Chromedriver.required_version = ENV['CHROMEDRIVER_VERSION'] if ENV['CHROMEDRIVER_VERSION']

            Selenium::WebDriver::Chrome::Options.new.tap do |opts|
              opts.binary = ENV['CHROME_BINARY'] if ENV['CHROME_BINARY']
              opts.add_argument('--no-sandbox')
              opts.headless! unless ENV['DISABLE_HEADLESS']
              opts.add_argument('--disable-dev-shm-usage')
              opts.add_argument('--disable-gpu')
            end
          else
            Selenium::WebDriver::Firefox::Options.new.tap do |opts|
              opts.binary = ENV['FIREFOX_BINARY'] if ENV['FIREFOX_BINARY']
              opts.headless! unless ENV['DISABLE_HEADLESS']
            end
          end

Capybara.register_driver :prism_checker do |app|
  Capybara::Selenium::Driver.new(app, browser: browser, capabilities: [options])
end

Capybara.configure do |config|
  config.default_driver = :prism_checker
  config.default_max_wait_time = 1
  config.app_host = "file://#{File.dirname(__FILE__)}/../test_site"
  config.ignore_hidden_elements = false
end
