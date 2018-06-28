$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nite_dependencies/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nite_dependencies"
  s.version     = "0.0.1"
  s.authors     = ["Nadav Blum"]
  s.email       = ["nadav@nite.org.il"]
  s.homepage    = ""
  s.summary     = "Add polymoriphic dependencies logic to NITE's apps"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  # s.add_dependency "rails", "~> 4.2.5.1"
  s.add_dependency "rails", "~> 4.1"

  s.add_development_dependency "sqlite3"
end
