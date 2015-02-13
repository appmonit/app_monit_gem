# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'app_monit/version'

Gem::Specification.new do |spec|
  spec.name          = "app_monit"
  spec.version       = AppMonit::VERSION
  spec.authors       = ["Redmar Kerkhoff", "Benoist Claassen"]
  spec.email         = ["redmar@appmon.it", "benoist@appmon.it"]
  spec.summary       = %q{Client gem for pushing events from ruby to the appmon.it service}
  spec.description   = %q{Client gem for pushing events from ruby to the appmon.it service}
  spec.homepage      = "https://appmon.it"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.5.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", ">= 5.2.2"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "webmock", ">= 1.17.1"
end
