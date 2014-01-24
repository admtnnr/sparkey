# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "sparkey"
  spec.version       = "1.2.0"
  spec.authors       = ["Adam Tanner"]
  spec.email         = ["adam@adamtanner.org"]
  spec.description   = %{ Ruby FFI bindings for Spotify's Sparkey }
  spec.summary       = %{ Ruby FFI bindings for Spotify's Sparkey }
  spec.homepage      = "https://github.com/adamtanner/sparkey"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "m"
end
