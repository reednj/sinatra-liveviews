# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/liveviews/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra-liveviews"
  spec.version       = Sinatra::Liveviews::VERSION
  spec.authors       = ["Nathan Reed"]
  spec.email         = ["reednj@gmail.com"]

  spec.summary       = %q{ create dashboards in sinatra that instantly update when the database changes }
  spec.homepage      = "https://github.com/reednj/sinatra-liveviews"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "sinatra"
  spec.add_runtime_dependency "sinatra-websocket"

end
