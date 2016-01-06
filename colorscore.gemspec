# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "colorscore/version"

Gem::Specification.new do |s|
  s.name        = "colorscore"
  s.version     = Colorscore::VERSION
  s.authors     = ["Milo Winningham"]
  s.email       = ["milo@winningham.net"]
  s.summary     = %q{Finds the dominant colors in an image.}
  s.description = %q{Finds the dominant colors in an image and scores them against a user-defined palette, using the CIE2000 Delta E formula.}
  
  s.add_dependency "color"
  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
