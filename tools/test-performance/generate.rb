# frozen_string_literal: true

require 'erb'

rhtml = ERB.new(File.read("#{File.dirname(__FILE__)}/performance.html.erb"))

File.write("#{File.dirname(__FILE__)}/performance.html", rhtml.result)
