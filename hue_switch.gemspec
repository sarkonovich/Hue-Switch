# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hue_switch/version'

Gem::Specification.new do |spec|
  spec.name          = "hue_switch"
  spec.version       = HueSwitch::VERSION
  spec.authors       = ["sarkonovich"]
  spec.email         = ["sarkonovich@ at gmail dot com"]

  spec.summary       = "A gem to easily control Hue lights"
  spec.description   = "A 'switch' controls Hue lights, groups, or scenes. Switches can be scheduled, and given dynamic effects."
  spec.homepage      = "http://www.github.com/sarkonovich/Hue-Switch"
  spec.licenses       = [ 'MIT' ]


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'
  spec.add_dependency 'chronic', '~> 0.10.0'
  spec.add_dependency 'chronic_duration', '~> 0'
  spec.add_dependency 'httparty', '~> 0.13.0'
  spec.add_dependency 'numbers_in_words', '~> 0.2.0' 
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 2.4.0'
end
