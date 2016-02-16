$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dependencies/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dependencies"
  s.version     = Dependencies::VERSION
  s.authors     = ["Nadav Blum"]
  s.email       = ["nadav@nite.org.il"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Dependencies."
  s.description = "TODO: Description of Dependencies."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "sqlite3"
end
