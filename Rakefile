# -*- ruby -*-
$:.unshift(File.dirname(__FILE__)+"/lib")
require 'rubygems'
require 'hoe'
require 'rserve'
#require 'rubyforge'
Hoe.plugin :git
#Hoe.plugin :rubyforge

require 'rspec'
require 'rspec/core/rake_task'


Hoe.spec 'rserve-client' do
   self.testlib=:rspec
   self.test_globs="spec/*_spec.rb"
   self.version=Rserve::VERSION
#   self.rubyforge_name = 'ruby-statsample' # if different than 'rserve'
   self.remote_rdoc_dir = "rserve-client"
   self.developer('Claudio Bustos', 'clbustos_AT_gmail.com')
   self.extra_dev_deps << ["rspec","~>2.0"]
end

# vim: syntax=ruby
