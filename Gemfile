source "https://rubygems.org"

# Heroku uses the ruby version to configure your application's runtime.
ruby "2.4.10"

# Rails
gem "rails", "~> 4.2.0"

# Database drivers
gem "pg"

# Heracles
gem "icelab-heracles", "2.0.0.beta67", path: "vendor/heracles", require: "heracles"

# Temporary dependency on forked sunspot queue (with Active Job support). Once
# this patch goes upstream, we can remove this, since Heracles is the right
# place to require sunspot-queue (but we can't use github dependencies in its
# gemspec).
gem "sunspot-queue", git: "https://github.com/timriley/sunspot-queue", ref: "649af734420db481fd0421dde152bbb9e7499bde"
gem "sunspot_rails", "2.1.1"

# Background worker
gem "que"

# Web server
gem "passenger", "~> 5.0.7"

# Rack middleware
gem "rack-canonical-host"
gem "rack-rewrite"

# Views
gem "jbuilder", "~> 2.0"
gem 'humanize', '~> 1.1.0'
gem "meta-tags"
gem "redcarpet"
gem "slim-rails"
gem "html_truncator"
gem "sanitize"

# Integrations
gem "bugsnag"

# Frontend
gem "color"
gem "coffee-rails", "~> 4.0.0"
gem "react-rails"
gem "sass-rails", "~> 5.0.6"
gem "turbolinks"
gem "uglifier", ">= 1.3.0"

# Rails assets
source "https://rails-assets.org" do
  gem "rails-assets-jquery"
  gem "rails-assets-jquery-ujs-standalone"
  gem "rails-assets-viewloader"
end
gem "embedly"

# Application
gem 'icalendar', '~> 2.3'
gem "iso8601"
gem "memoit"
gem "dotiw"
gem "staccato"

# Utilities
gem "ffaker"

# Sitemap
gem "sitemap_generator"
gem "fog"

group :production do
  gem "memcachier"
  gem "rails_12factor"
  gem "rails_autoscale_agent"
end

group :production, :development do
  gem "dalli"
end

group :test do
  gem "capybara", git: "https://github.com/teamcapybara/capybara", ref: "5849ecb66e7e961b1e3eee4fe62e67fb0b1061f5" # RSpec 3 deprecations, waiting for the next gem release.
  gem "database_cleaner"
  gem "poltergeist"
  gem "shoulda-matchers"
  gem "simplecov", "~> 0.7.1" # https://github.com/colszowka/simplecov/issues/281
end

group :test, :development do
  gem "dotenv", git: "https://github.com/bkeepers/dotenv", ref: "a47020f6c414e0a577680b324e61876a690d2200"
  gem "dotenv-rails"
  gem "rspec-rails", "~> 3.5.0"
  gem "pry-byebug"
end

# Development tools
group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "foreman"
  gem "launchy"
  gem "letter_opener"
  gem "quiet_assets"
  gem "spring"
  gem "spring-commands-rspec"
  gem "sunspot_solr", "2.1.1"

  # Guard et al
  gem "guard", "~> 2"
  gem "guard-rspec"
  gem "guard-livereload"
  gem "rb-fsevent"
end
