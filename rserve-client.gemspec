# -*- encoding: utf-8 -*-
require File.expand_path("../lib/rserve", __FILE__)

Gem::Specification.new do |s|
  s.name = "rserve-client"
  s.version = Rserve::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Claudio Bustos']
  s.email = []
  s.homepage = "http://rubygems.org/gems/rserve-client"
  s.summary = "Rserve client for ruby"
  s.description = "Rserve client for ruby"

  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec"
  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
