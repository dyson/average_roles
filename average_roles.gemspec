$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "average_roles/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "average_roles"
  s.version     = AverageRoles::VERSION
  s.authors     = ["Dyson Simmons"]
  s.email       = ["dysonsimmons@gmail.com"]
  s.homepage    = "https://github.com/dyson/average_roles"
  s.summary     = "Rails 4 roles based on a tree structure."
  s.description = "Add roles to models using postgres_tree. It's average because it doesn't do much else."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "postgres_tree", "~> 0.0"

  s.add_development_dependency "coveralls"
end
