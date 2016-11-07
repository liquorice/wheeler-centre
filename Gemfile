source "https://rubygems.org"

# Heroku uses the ruby version to configure your application's runtime.
ruby "2.1.6"

# Rails
gem "rails", "~> 4.1.0"

# Database drivers
gem "pg"

# Heracles
gem "heracles", "~> 1.0.6", source: "https://gem.fury.io/icelab/"

# Cache Buster
gem 'varnisher'

# Temporary dependency on forked sunspot queue (with Active Job support). Once
# this patch goes upstream, we can remove this, since Heracles is the right
# place to require sunspot-queue (but we can't use github dependencies in its
# gemspec).
gem "sunspot-queue", github: "timriley/sunspot-queue", ref: "649af734420db481fd0421dde152bbb9e7499bde"

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
gem "sass-rails", "~> 4.0.2"
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

# Temporary for the Blueprint import
# gem "syck", "1.0.1"
# gem "rdiscount"
# gem 'google-api-client',      '~> 0.8.2', :require => 'google/api_client'
# gem "trollop"
# gem "aws-sdk"
# gem "net-scp"
# gem "thin"
# gem "nokogiri"
# gem "progress_bar"

# Sitemap
gem "sitemap_generator"
gem "fog"

group :production do
  gem "rails_12factor"
  gem "dalli"      # memcache on production
  gem "memcachier" # memcache on production
end

group :test do
  gem "capybara", github: "jnicklas/capybara" # RSpec 3 deprecations, waiting for the next gem release.
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "fuubar", "~> 2.0.0"
  gem "poltergeist"
  gem "minitest" # Remove this after https://github.com/thoughtbot/shoulda-matchers/issues/408 is fixed.
  gem "shoulda-matchers"
  gem "simplecov", "~> 0.7.1" # https://github.com/colszowka/simplecov/issues/281
end


group :test, :development do
  gem "dotenv", github: "bkeepers/dotenv"
  gem "dotenv-rails"
  gem "rspec-rails", "~> 3.0.0.beta2"
end

# Development tools
group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "foreman"
  gem "launchy"
  gem "quiet_assets"
  # gem "rack-mini-profiler"
  gem "spring"
  gem "spring-commands-rspec"
  gem "sunspot_solr"

  # Guard et al
  gem "guard", "~> 2"
  gem "guard-rspec"
  gem "guard-livereload"
  gem "rb-fsevent"
end
