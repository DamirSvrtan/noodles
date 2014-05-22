# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'noodles/version'

Gem::Specification.new do |spec|
  spec.name          = "noodles"
  spec.version       = Noodles::VERSION
  spec.authors       = ["Damir Svrtan"]
  spec.email         = ["damir.svrtan@gmail.com"]
  spec.summary       = "Rack based web framework"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'websocket-rack'
  spec.add_runtime_dependency 'multi_json'
  spec.add_runtime_dependency 'tilt'
  spec.add_runtime_dependency 'slim'
  spec.add_runtime_dependency 'thor'
end
