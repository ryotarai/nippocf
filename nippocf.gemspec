# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nippocf/version'

Gem::Specification.new do |spec|
  spec.name          = "nippocf"
  spec.version       = Nippocf::VERSION
  spec.authors       = ["Ryota Arai"]
  spec.email         = ["ryota.arai@gmail.com"]
  spec.summary       = "Write nippo (daily report in Japanese) on Atlassian Confluence in Markdown"
  spec.homepage      = "https://github.com/ryotarai/nippocf"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "github-markdown"
  spec.add_dependency "nokogiri"
  spec.add_dependency "ruby-keychain"
  spec.add_dependency "socksify"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
