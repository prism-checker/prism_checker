require 'rspec/expectations'

RSpec::Matchers.define :fail_with_report do |report_expected|
  match do |checker|
    checker.result == false && checker.report == report_expected
  end

  failure_message do |_actual|
    checker.report
  end
end
