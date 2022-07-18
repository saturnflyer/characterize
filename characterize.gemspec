# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'characterize/version'

Gem::Specification.new do |spec|
  spec.name          = "characterize"
  spec.version       = Characterize::VERSION
  spec.authors       = ["'Jim Gay'"]
  spec.email         = ["jim@saturnflyer.com"]
  spec.description   = %q{Use plain modules like presenters}
  spec.summary       = %q{Use plain modules like presenters}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "casting", "~> 1.0.1"
end
