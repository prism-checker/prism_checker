# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'prism_checker'
  s.version     = '1.0.1'
  s.required_ruby_version = '>= 2.5'
  s.platform    = Gem::Platform::RUBY
  s.license     = 'BSD-3-Clause'
  s.authors     = ['Ganglion-17']
  s.email       = %w[ganglion1717@gmail.com]
  s.homepage    = 'https://github.com/prism-checker/prism_checker'
  s.summary     = 'Short and easy-to-read browser tests with clear error messages'
  s.description = <<~DESCR
    prism_checker is an extension for rspec and minitest, built on top of the site_prism gem and using its page object model.
    It allows you to write short, easy-to-read browser tests with clear error messages
  DESCR
  s.files        = Dir.glob('lib/**/*') + %w[LICENSE.md README.md]
  s.require_path = 'lib'
  s.add_dependency 'site_prism', '>= 3.0'

  s.add_development_dependency 'byebug', '~> 11.1'
  s.add_development_dependency 'dotenv'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'rubocop', '~> 1.11.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.10.1'
  s.add_development_dependency 'rubocop-rspec', '~> 2.2.0'
  s.add_development_dependency 'selenium-webdriver', '>= 3.13', '< 4.1'
  s.add_development_dependency 'simplecov', '~> 0.22'
  s.add_development_dependency 'simplecov_json_formatter'
  s.add_development_dependency 'webdrivers', '~> 4.6'
end
