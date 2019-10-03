# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interpret_date/version'

Gem::Specification.new do |spec|
  spec.name          = "interpret_date"
  spec.version       = InterpretDate::VERSION
  spec.authors       = ["Squaremouth"]
  spec.email         = ["developers@squaremouth.com"]
  spec.summary       = %q{Mixin for easily parsing American formatted date strings into Date objects.}
  spec.description   = %q{Module to provide helper methods for interpreting American formatted date strings.}
  spec.homepage      = "https://github.com/sqm/interpret_date"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", "~> 5.1"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency "rspec", "~> 3.2"
end
