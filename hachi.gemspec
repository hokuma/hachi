$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hachi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hachi"
  s.version     = Hachi::VERSION
  s.authors     = ["hokuma"]
  s.email       = ["okuma@hokuma.net"]
  s.homepage    = "https://github.com/hokuma/hachi"
  s.summary     = "hachi supports communications between api servers and clients."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"
  s.add_dependency 'json_schema'
  s.add_dependency 'sqlite3'
  s.add_dependency 'react-rails'
  s.add_dependency 'heroics'
  s.add_dependency 'bootstrap-sass', '~> 3.3.6'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'jquery-rails'
  s.add_development_dependency 'prmd'
  s.add_development_dependency 'byebug'
end
