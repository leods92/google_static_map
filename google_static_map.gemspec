$:.push File.expand_path("../lib", __FILE__)

require "google_static_map/version"

Gem::Specification.new do |s|
  s.name        = "google_static_map"
  s.version     = GoogleStaticMap::VERSION
  s.license     = "MIT"
  s.summary     = "A ruby interface to generate Google Maps static images."
  s.description = "Google Maps Image APIs are pretty straightforward and this gem makes using them even easier."
  s.authors     = ["Leonardo D. Schlossmacher"]
  s.email       = ["e@leods92.com"]
  # s.homepage    = "TODO"

  s.files = Dir["lib/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "activemodel", ">= 3.2"
  s.add_dependency "activesupport", ">= 3.2"

  # Test related dependencies
  s.add_development_dependency 'guard-rspec', "~> 3.0.0"
  s.add_development_dependency 'rspec', "~> 2.14.0"
  s.add_development_dependency 'shoulda-matchers', '~> 2.3.0'
end
