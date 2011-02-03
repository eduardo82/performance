# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "performance/version"

Gem::Specification.new do |s|
  s.name        = "performance"
  s.version     = Performance::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eduardo de Oliveira Vasconcelos"]
  s.email       = ["eduardooliveiravasconcelos@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Gem has a goal of get better performance in server side}
  s.description = %q{Get better performance in Rails 3 app}

  s.rubyforge_project = "performance"
  
  s.add_dependency "jammit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
