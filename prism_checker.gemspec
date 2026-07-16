# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'prism_checker'
  s.version     = '1.0.1'
  s.required_ruby_version = '>= 3.1'
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

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/prism-checker/prism_checker/issues',
    'changelog_uri' => 'https://github.com/prism-checker/prism_checker/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/prism-checker/prism_checker/blob/main/README.md',
    'source_code_uri' => 'https://github.com/prism-checker/prism_checker',
    'rubygems_mfa_required' => 'true'
  }

  s.files        = Dir.glob('lib/**/*') + %w[CHANGELOG.md LICENSE.md README.md]
  s.require_path = 'lib'
  s.extra_rdoc_files = %w[CHANGELOG.md LICENSE.md README.md]

  s.add_dependency 'site_prism', '>= 5.0', '< 7'
end
