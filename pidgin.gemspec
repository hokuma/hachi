$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pidgin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pidgin"
  s.version     = Pidgin::VERSION
  s.authors     = ["hokuma"]
  s.email       = ["okuma@hokuma.net"]
  s.homepage    = "https://github.com/hokuma/pidgin"
  s.summary     = "Pidgin supports communications between api servers and clients."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"
  s.add_dependency 'json_schema'
  s.add_dependency 'sqlite3'
end
