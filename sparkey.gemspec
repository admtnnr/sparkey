# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sparkey/version'

Gem::Specification.new do |spec|
  spec.name          = "sparkey"
  spec.version       = Sparkey::VERSION
  spec.authors       = ["Adam Tanner"]
  spec.email         = ["adam@adamtanner.org"]
  spec.description   = %q{Ruby FFI bindings for Spotify's Sparkey}
  spec.summary       = %q{Ruby FFI bindings for Spotify's Sparkey}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
