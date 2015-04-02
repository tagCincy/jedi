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
  spec.add_development_dependency "rspec", "~> 3.2.0"
  spec.add_development_dependency "coveralls", "~> 0.7.11"

  spec.add_runtime_dependency 'thor', '~> 0.19.1'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6.6.2'
  spec.add_runtime_dependency 'rubyzip', '>= 1.0.0'
  spec.add_runtime_dependency 'coffee-script', '~> 2.3.0'
  spec.add_runtime_dependency 'sass', '~> 3.4.13'
  spec.add_runtime_dependency 'haml', '~> 4.0.6'
  spec.add_runtime_dependency 'uglifier', '~> 2.7.1'
  spec.add_runtime_dependency 'yui-compressor', '~> 0.12.0'
  spec.add_runtime_dependency 'sprockets', '~> 2.12.3'
  spec.add_runtime_dependency 'sprockets-sass', '~> 1.3.1'
end
