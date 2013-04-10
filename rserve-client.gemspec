# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rserve-client"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Claudio Bustos"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDMjCCAhqgAwIBAgIBADANBgkqhkiG9w0BAQUFADA/MREwDwYDVQQDDAhjbGJ1\nc3RvczEVMBMGCgmSJomT8ixkARkWBWdtYWlsMRMwEQYKCZImiZPyLGQBGRYDY29t\nMB4XDTEwMDMyOTIxMzg1NVoXDTExMDMyOTIxMzg1NVowPzERMA8GA1UEAwwIY2xi\ndXN0b3MxFTATBgoJkiaJk/IsZAEZFgVnbWFpbDETMBEGCgmSJomT8ixkARkWA2Nv\nbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALf8JVMGqE7m5kYb+PNN\nneZv2pcXV5fQCi6xkyG8bi2/SIFy/LyxuvLzEeOxBeaz1Be93bayIUquOIqw3dyw\n/KXWa31FxuNuvAm6CN8fyeRYX/ou4cw3OIUUnIvB7RMNIu4wbgeM6htV/QEsNLrv\nat1/mh9JpqawPrcjIOVMj4BIp67vmzJCaUf+S/H2uYtSO09F+YQE3tv85TPeRmqU\nyjyXyTc/oJiw1cXskUL8UtMWZmrwNLHXuZWWIMzkjiz3UNdhJr/t5ROk8S2WPznl\n0bMy/PMIlAbqWolRn1zl2VFJ3TaXScbqImY8Wf4g62b/1ZSUlGrtnLNsCYXrWiso\nUPUCAwEAAaM5MDcwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0OBBYEFGu9\nrrJ1H64qRmNNu3Jj/Qjvh0u5MA0GCSqGSIb3DQEBBQUAA4IBAQCV0Unka5isrhZk\nGjqSDqY/6hF+G2pbFcbWUpjmC8NWtAxeC+7NGV3ljd0e1SLfoyBj4gnFtFmY8qX4\nK02tgSZM0eDV8TpgFpWXzK6LzHvoanuahHLZEtk/+Z885lFene+nHadkem1n9iAB\ncs96JO9/JfFyuXM27wFAwmfHCmJfPF09R4VvGHRAvb8MGzSVgk2i06OJTqkBTwvv\nJHJdoyw3+8bw9RJ+jLaNoQ+xu+1pQdS2bb3m7xjZpufml/m8zFCtjYM/7qgkKR8z\n/ZZt8lCiKfFArppRrZayE2FVsps4X6WwBdrKTMZ0CKSXTRctbEj1BAZ67eoTvBBt\nrpP0jjs0\n-----END CERTIFICATE-----\n"]
  s.date = "2011-12-26"
  s.description = "Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/).\n\nFollows closely the new Java client API, but maintains all Ruby conventions when possible."
  s.email = ["clbustos_AT_gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Introduction.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Introduction.txt", "Manifest.txt", "README.txt"]
  s.homepage = "http://github.com/clbustos/Rserve-Ruby-client"
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ruby-statsample"
  s.rubygems_version = "1.8.25"
  s.summary = "Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/)"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<hoe>, ["~> 2.12"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<hoe>, ["~> 2.12"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<hoe>, ["~> 2.12"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
  end
end
