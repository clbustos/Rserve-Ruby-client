require 'rspec'
require_relative '../lib/rserve'
require 'matrix'
require 'pp'

INFINITY = +1.0/0.0 if RUBY_VERSION < "1.9"

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
