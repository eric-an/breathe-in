require_relative './lib/breathe_in/version'

Gem::Specification.new do |s|
  s.name        = 'breathe_in'
  s.version     = BreatheIn::VERSION
  s.date        = '2016-01-20'
  s.summary     = "City AQI value"
  s.description = "Check the Air Quality Index (AQI) to see how clean or polluted the air is in your city."
  s.authors     = ["Eric An"]
  s.email       = 'erican@me.com'
  s.files       = ["lib/breathe_in.rb", "lib/breathe_in/cli.rb", "lib/breathe_in/scraper.rb", "lib/breathe_in/city.rb", "config/environment.rb"]
  s.homepage    = 'https://rubygems.org/gems/breathe_in'
  s.license     = 'MIT'
  s.executables << 'breathe_in'

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", ">= 0"
  s.add_development_dependency "nokogiri", ">= 0"
  s.add_development_dependency "pry", ">= 0"
end
