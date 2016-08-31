# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "factory_girl_any_instance"
  spec.version       = File.read(File.expand_path("../VERSION", __FILE__)).chomp
  spec.authors       = ["Brian Durand"]
  spec.email         = ["bbdurand@gmail.com"]
  spec.summary       = "Adds helper methods to FactoryGirl to memoize instances to speed up test suite"
  spec.description   = "Adds helper methods to FactoryGirl to memoize instances to speed up test suite."
  spec.homepage      = "https://github.com/bdurand/factory_girl_any_instance"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>=2.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
