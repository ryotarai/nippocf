# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nippocf/version'

Gem::Specification.new do |spec|
  spec.name          = "nippocf"
  spec.version       = Nippocf::VERSION
  spec.authors       = ["Ryota Arai"]
  spec.email         = ["ryota.arai@gree.net"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redcarpet"
  spec.add_dependency "nokogiri"
  spec.add_dependency "ruby-keychain"
  spec.add_dependency "socksify"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end