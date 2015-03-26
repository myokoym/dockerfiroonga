# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dockerfiroonga/version'

Gem::Specification.new do |spec|
  spec.name          = "dockerfiroonga"
  spec.version       = Dockerfiroonga::VERSION
  spec.authors       = ["Masafumi Yokoyama"]
  spec.email         = ["yokoyama@clear-code.com"]

  spec.summary       = %q{Dockerfile generator for Groonga family.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/myokoym/dockerfiroonga"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f)}
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency("test-unit", ">= 3.0.0")
  spec.add_development_dependency("test-unit-notify")
  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
end
