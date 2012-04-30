# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nested_css/version"

Gem::Specification.new do |s|
  s.name        = "nested_css"
  s.version     = NestedCSS::VERSION
  s.authors     = ["Neil Ang"]
  s.email       = ["neilang@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Parses CSS and prints it in a nested form}
  s.description = %q{Convert traditional CSS into the nested selector form found in LESS and SCSS/SASS}

  s.rubyforge_project = "nested_css"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "css_parser"
end
