lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 'client/version'

Gem::Specification.new do |s|
  s.name        = 'shutterstock-client'
  s.version     = ShutterstockAPI::VERSION
  s.date        = '2014-02-21'
  s.summary     = 'A ruby client to work with shutterstock api'
  s.description = "see summary"
  s.authors     = ['jhogue, vkajjam, flindiakos, wusher, alicht']
  s.email       = 'vkajjam@shutterstock.com'
  s.files       = ['lib/shutterstock-client.rb']
  s.require_paths = ["lib"]
  s.homepage    = 'https://github.com/shutterstock/ruby-shutterstock-api' 
  s.license     = 'Copyright shutterstock.com 2014'
  s.add_dependency "httparty", "~> 0.14"
  s.add_dependency "activesupport", "~> 5.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "vcr", "~> 3.0"
  s.add_development_dependency "webmock", "~> 2.3"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "guard", "~> 2.14"
  s.add_development_dependency "guard-rspec", "~> 4.7"
  s.add_development_dependency "rb-readline", "~> 0.5"
  s.add_development_dependency "rubocop", "~> 0.46"
end
