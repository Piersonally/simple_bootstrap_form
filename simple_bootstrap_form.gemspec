# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_bootstrap_form/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_bootstrap_form"
  spec.version       = SimpleBootstrapForm::VERSION
  spec.authors       = ["Sam Pierson"]
  spec.email         = ["gems@sampierson.com"]
  spec.summary       = %q{Bootstrap 3 Form Helper}
  spec.description   = %q{A form helper with a 'Simple Form'-like interface, that supports Bootstrap 3}
  spec.homepage      = "https://github.com/Piersonally/simple_bootstrap_form"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails", ">= 3.0.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "nokogiri" # used by has_element matcher
  spec.add_runtime_dependency "rails", ">= 4"
end
