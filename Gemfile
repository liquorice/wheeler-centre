source "https://rubygems.org"

# Heroku uses the ruby version to configure your application's runtime.
ruby "2.7.5"

# Rails
gem "rails", "~> 4.2.0"

# Database drivers
gem "pg", "~> 0.20.0"

# Heracles
gem "icelab-heracles", "2.0.0.beta67", path: "vendor/heracles", require: "heracles"

# Temporary dependency on forked sunspot queue (with Active Job support). Once
# this patch goes upstream, we can remove this, since Heracles is the right
# place to require sunspot-queue (but we can't use github dependencies in its
# gemspec).
gem "sunspot-queue", git: "https://github.com/timriley/sunspot-queue", ref: "649af734420db481fd0421dde152bbb9e7499bde"
gem "sunspot_rails", "2.1.1"

# Background worker
gem "que", "~> 0.12.1"

# Web server
gem "passenger", "~> 5.0.7"

# Rack middleware
gem "rack-canonical-host", "~> 0.2.3"
gem "rack-rewrite", "~> 1.5.1"

# Views
gem "jbuilder", "~> 2.0"
gem 'humanize', '~> 1.1.0'
gem "meta-tags", "~> 2.4.0"
gem "redcarpet", "~> 3.4.0"
gem "slim-rails", "~> 3.0.1"
gem "html_truncator", "~> 0.4.1"
gem "sanitize", "~> 4.4.0"

# Integrations
gem "bugsnag", "~> 5.3.2"

# Frontend
gem "color", "~> 1.8"
gem "coffee-rails", "~> 4.0.0"
gem "react-rails", "~> 0.9.0.0"
gem "sass-rails", "~> 5.0.6"
gem "turbolinks", "~> 2.5.3"
gem "uglifier", ">= 1.3.0"

# Rails assets
source "https://rails-assets.org" do
  gem "rails-assets-jquery", "~> 1.9.1"
  gem "rails-assets-jquery-ujs-standalone", "~> 1.0.0"
  gem "rails-assets-viewloader", "~> 2.1.0"
end
gem "embedly", "~> 1.9.1"

# Application
gem 'icalendar', '~> 2.3'
gem "iso8601", "~> 0.9.1"
gem "memoit", "~> 0.2.0"
gem "dotiw", "~> 3.1.1"
gem "staccato", "~> 0.5.1"

# Utilities
gem "ffaker", "~> 2.5.0"

# Sitemap
gem "sitemap_generator", "~> 5.3.1"
gem "fog", "~> 1.40.0"

gem 'bigdecimal', '1.3.5'

group :production do
  gem "memcachier", "~> 0.0.2"
  gem "rails_12factor", "~> 0.0.3"
  gem "rails_autoscale_agent", "~> 0.4.0"
end

group :production, :development do
  gem "dalli", "~> 2.7.6"
end

group :test do
  gem "capybara", git: "https://github.com/teamcapybara/capybara", ref: "5849ecb66e7e961b1e3eee4fe62e67fb0b1061f5" # RSpec 3 deprecations, waiting for the next gem release.
  gem "database_cleaner", "~> 1.6.0"
  gem "factory_girl_rails", "~> 4.8.0"
  gem "fuubar", "~> 2.0.0"
  gem "poltergeist", "~> 1.15.0"
  gem "minitest", "~> 5.10.1" # Remove this after https://github.com/thoughtbot/shoulda-matchers/issues/408 is fixed.
  gem "shoulda-matchers", "~> 3.1.1"
  gem 'simplecov', "~> 0.7.1", require: false
end

group :test, :development do
  gem "dotenv", git: "https://github.com/bkeepers/dotenv", ref: "a47020f6c414e0a577680b324e61876a690d2200"
  gem "dotenv-rails", "~> 2.2.1"
  gem "rspec-rails", "~> 3.5.0"
end

# Development tools
group :development do
  gem "better_errors", "~> 2.1.1"
  gem "binding_of_caller", "~> 0.7.2"
  gem "foreman", "~> 0.84.0"
  gem "launchy", "~> 2.4.3"
  gem "letter_opener", "~> 1.7.0"
  gem "quiet_assets", "~> 1.1.0"
  gem "spring", "~> 2.0.1"
  gem "spring-commands-rspec", "~> 1.0.4"
  gem "sunspot_solr", "2.1.1"
  gem "pry-byebug", "~> 3.6.0"

  # Guard et al
  gem "guard", "~> 2"
  gem "guard-rspec", "~> 4.7.3"
  gem "guard-livereload", "~> 2.5.2"
  gem "rb-fsevent", "~> 0.9.8"
end
