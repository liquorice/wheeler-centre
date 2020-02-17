$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "heracles/sites/<%= snake_case_site_name %>/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "<%= snake_case_site_name %>"
  s.version     = Heracles::Sites::<%= camel_case_site_name %>::VERSION
  s.authors     = ["Heracles Site Author"]
  s.email       = ["hello@example.com"]
  s.homepage    = "http://example.com/"
  s.summary     = "Heracles site engine template."
  s.description = "Heracles site engine template."

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "sqlite3"
end
