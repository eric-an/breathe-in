# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'breathe_in/version'

Gem::Specification.new do |spec|
  spec.name          = 'breathe_in'
  spec.version       = BreatheIn::VERSION
  spec.authors       = ['eric-an']
  spec.email         = ['erican@me.com']

  spec.summary       = %q{air quality scraper gem}
  spec.description   = %q{Check the air quality index (AQI) for a zipcode and see how clean or polluted the air is in your city.}
  spec.homepage      = "https://rubygems.org/gems/breathe_in"
  spec.license       = 'MIT'
  spec.executables << 'breathe_in'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "nokogiri"
end
