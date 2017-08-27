# -*- encoding: utf-8 -*-
require_relative "lib/rserve/version"

Gem::Specification.new do |s|
  s.name = "rserve-client"
  s.version = Rserve::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Claudio Bustos']
  s.email = ["clbustos_at_gmail_dot_com"]
  s.homepage = "http://rubygems.org/gems/rserve-client"
  s.summary = "Rserve client for ruby"
  s.description = "Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/)."
  s.license="LGPL-2.1+"
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "bundler", '~>1.0', ">= 1.0.0"
  s.add_development_dependency "rspec", '~>0'
  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
