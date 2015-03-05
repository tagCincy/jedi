# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jedi/version'

Gem::Specification.new do |spec|
  spec.name          = "jedi"
  spec.version       = Jedi::VERSION
  spec.authors       = ["Tim Guibord"]
  spec.email         = ["timguibord@gmail.com"]
  spec.summary       = %q{Force.com Application Goodness}
  spec.description   = %q{Ruby based Force.com Application development framework}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10.1"
end
