# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_truth_table/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_truth_table"
  spec.version       = RspecTruthTable::VERSION
  spec.authors       = ["Courtney de Lautour"]
  spec.email         = ["clautour@thefrontiergroup.com.au"]
  spec.summary       = %q{Provides a simple DSL for testing complex boolean methods}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
