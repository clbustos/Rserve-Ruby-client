# -*- ruby -*-
require 'rubygems'
require_relative 'lib/rserve'
require 'rspec'
require 'rspec/core/rake_task'

require 'bundler'
require 'bundler/gem_tasks'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end


RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# vim: syntax=ruby


