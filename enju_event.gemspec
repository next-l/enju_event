$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enju_event/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_event"
  s.version     = EnjuEvent::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["nabeta@fastmail.fm"]
  s.homepage    = "https://github.com/next-l/enju_event"
  s.summary     = "enju_event plugin"
  s.description = "Event management for Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/{log,private,solr,tmp}/**/*"] - Dir["spec/dummy/db/*.sqlite3"]

  s.add_dependency "enju_message", "~> 0.3.2"
  s.add_dependency "ri_cal"
  s.add_dependency "jbuilder"

  s.add_development_dependency "enju_leaf", "~> 1.3.4.rc.2"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 4.0"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "sunspot_solr", "~> 2.5"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rspec-activemodel-mocks"
  s.add_development_dependency "redis-rails"
  s.add_development_dependency "coveralls", "~> 0.8.23"
  s.add_development_dependency "resque"
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "puma"
  s.add_development_dependency "annotate"
  s.add_development_dependency "brakeman"
  s.add_development_dependency "rails", "~> 5.2"
  s.add_development_dependency "sprockets", "~> 3.7"
end
