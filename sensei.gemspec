# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensei/version'

Gem::Specification.new do |spec|
  spec.name          = "sensei"
  spec.version       = Sensei::VERSION
  spec.authors       = ["Mattias Putman"]
  spec.email         = ["mattias.putman@gmail.com"]
  spec.description   = %q{Sensei}
  spec.summary       = %q{Sensei}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.executables   = %w{sensei}

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
