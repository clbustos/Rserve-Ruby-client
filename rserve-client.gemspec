# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rserve-client"
  s.version = "0.3.0.20121102021317"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Claudio Bustos"]
  s.date = "2012-11-02"
  s.description = "Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/).\n\nFollows closely the new Java client API, but maintains all Ruby conventions when possible."
  s.email = ["clbustos_AT_gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Introduction.txt", "Manifest.txt", "README.txt"]
  s.files = [".autotest", ".rspec", "History.txt", "Introduction.txt", "Manifest.txt", "README.txt", "Rakefile", "benchmark/benchmark.rb", "benchmark/comparison_2010_06_07.xls", "benchmark/comparison_2010_06_07_using_pack.xls", "benchmark/plot.rb", "data/gettysburg.txt", "examples/gettysburg.rb", "examples/hello_world.rb", "examples/lowless.rb", "examples/regression.rb", "lib/rserve.rb", "lib/rserve/connection.rb", "lib/rserve/engine.rb", "lib/rserve/packet.rb", "lib/rserve/protocol.rb", "lib/rserve/protocol/rexpfactory.rb", "lib/rserve/rexp.rb", "lib/rserve/rexp/double.rb", "lib/rserve/rexp/environment.rb", "lib/rserve/rexp/expressionvector.rb", "lib/rserve/rexp/factor.rb", "lib/rserve/rexp/function.rb", "lib/rserve/rexp/genericvector.rb", "lib/rserve/rexp/integer.rb", "lib/rserve/rexp/language.rb", "lib/rserve/rexp/list.rb", "lib/rserve/rexp/logical.rb", "lib/rserve/rexp/null.rb", "lib/rserve/rexp/raw.rb", "lib/rserve/rexp/reference.rb", "lib/rserve/rexp/s4.rb", "lib/rserve/rexp/string.rb", "lib/rserve/rexp/symbol.rb", "lib/rserve/rexp/unknown.rb", "lib/rserve/rexp/vector.rb", "lib/rserve/rexp/wrapper.rb", "lib/rserve/rfactor.rb", "lib/rserve/rlist.rb", "lib/rserve/session.rb", "lib/rserve/talk.rb", "lib/rserve/withattributes.rb", "lib/rserve/withnames.rb", "spec/rserve_connection_on_unix_spec.rb", "spec/rserve_connection_spec.rb", "spec/rserve_double_spec.rb", "spec/rserve_genericvector_spec.rb", "spec/rserve_integer_spec.rb", "spec/rserve_logical_spec.rb", "spec/rserve_packet_spec.rb", "spec/rserve_protocol_spec.rb", "spec/rserve_rexp_spec.rb", "spec/rserve_rexp_to_ruby_spec.rb", "spec/rserve_rexp_wrapper_spec.rb", "spec/rserve_rexpfactory_spec.rb", "spec/rserve_rfactor_spec.rb", "spec/rserve_rlist_spec.rb", "spec/rserve_session_spec.rb", "spec/rserve_spec.rb", "spec/rserve_talk_spec.rb", "spec/rserve_withnames_spec.rb", "spec/spec_helper.rb", "spec/rserve_with2dnames_spec.rb", "spec/rserve_with2dsizes_spec.rb", ".gemtest"]
  s.homepage = "http://github.com/clbustos/Rserve-Ruby-client"
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ruby-statsample"
  s.rubygems_version = "1.8.24"
  s.summary = "Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/)"
  s.test_files = ["spec/rserve_connection_on_unix_spec.rb", "spec/rserve_connection_spec.rb", "spec/rserve_double_spec.rb", "spec/rserve_genericvector_spec.rb", "spec/rserve_integer_spec.rb", "spec/rserve_logical_spec.rb", "spec/rserve_packet_spec.rb", "spec/rserve_protocol_spec.rb", "spec/rserve_rexp_spec.rb", "spec/rserve_rexp_to_ruby_spec.rb", "spec/rserve_rexp_wrapper_spec.rb", "spec/rserve_rexpfactory_spec.rb", "spec/rserve_rfactor_spec.rb", "spec/rserve_rlist_spec.rb", "spec/rserve_session_spec.rb", "spec/rserve_spec.rb", "spec/rserve_talk_spec.rb", "spec/rserve_with2dnames_spec.rb", "spec/rserve_with2dsizes_spec.rb", "spec/rserve_withnames_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.1"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<hoe>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<hoe>, ["~> 3.1"])
  end
end
