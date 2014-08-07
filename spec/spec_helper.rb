$:.unshift(File.dirname(__FILE__)+"/../lib")
require 'rspec'
require 'rserve'
require 'matrix'
require 'pp'


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end
