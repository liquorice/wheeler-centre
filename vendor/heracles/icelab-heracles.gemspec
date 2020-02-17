$:.push File.expand_path("../lib", __FILE__)

require "heracles/engines"
require "heracles/version"

Gem::Specification.new do |s|
  s.name        = "icelab-heracles"
  s.version     = Heracles::VERSION
  s.authors     = ["Icelab"]
  s.email       = ["hello@icelab.com.au"]
  s.homepage    = "http://icelab.com.au/"
  s.summary     = "A Ruby on Rails CMS"
  s.description = "An engine-based, multi-site CMS for Ruby on Rails."
  s.license     = "Copyright Icelab 2013-#{Time.now.year}. All rights reserved."

  s.files       = Dir["Rakefile", "README.md", "lib/**/*", "{#{Heracles::ENGINE_NAMES.join(",")}}/{Rakefile,app,config,db,lib,vendor}{,/**/*}"]

  # Core
  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "acts-as-taggable-on", "~> 3.4.3"
  s.add_dependency "ancestry", "~> 2.1.0"
  s.add_dependency "cloudinary", "~> 1.1.0"
  s.add_dependency "contracts", "~> 0.8"
  s.add_dependency "friendly_id", "~> 5.1.0"
  s.add_dependency "memoit", "~> 0.2.0"
  s.add_dependency "nokogiri", ">= 1.6.3" # needed for proper character encoding on Heroku
  s.add_dependency "progress_bar", "~> 1.0.3"
  s.add_dependency "rails-observers", "~> 0.1.2"
  s.add_dependency "refile" # you must specify the repo's git source in the app's `Gemfile`
  s.add_dependency "refile-s3" # you must specify the repo's git source in the app's `Gemfile`
  s.add_dependency "ranked-model", "~> 0.4.0"
  s.add_dependency "render_anywhere", "~> 0.0.11"
  s.add_dependency "transloadit-rails", "~> 1.1.1"
  s.add_dependency "pg_search", "~> 1.0.5"

  # Core, Admin
  s.add_dependency "interactor", "~> 3.1.0"
  s.add_dependency "nestive", "~> 0.6.0"
  s.add_dependency "varnisher", "~> 1.1.0"

  # Admin - backend
  s.add_dependency "api-pagination", "~> 4.1.0"
  s.add_dependency "decent_exposure", "~> 2.3.2"
  s.add_dependency "jbuilder", "~> 2.2.12"
  s.add_dependency "kaminari", "~> 0.16.3"
  s.add_dependency "responders", "~> 2.0"
  s.add_dependency "slim-rails", "~> 3.0.1"
  s.add_dependency "aws-sdk", "~> 2.1.13"

  # Admin - front-end
  s.add_dependency "autoprefixer-rails", "~> 5.1.8"
  s.add_dependency "bourbon", "~> 4.0"
  s.add_dependency "coffee-rails", "~> 4.0.1"
  s.add_dependency "font-awesome-rails", "~> 4.3.0.0"
  s.add_dependency "react-rails", "~> 0.9.0"
  s.add_dependency "sass-rails", "~> 5.0"
  s.add_dependency "turbolinks", "~> 2.5.3"

  # Admin - Rails assets
  s.add_dependency "rails-assets-fastclick", "~> 1.0.6"
  s.add_dependency "rails-assets-filament-sticky", "~> 0.1.4"
  s.add_dependency "rails-assets-html5shiv", "~> 3.7.2"
  s.add_dependency "rails-assets-jquery", "~> 1.9.1"
  s.add_dependency "rails-assets-jquery-timepicker-jt", "~> 1.5.3"
  s.add_dependency "rails-assets-jquery-ujs-standalone", "~> 1.0.0"
  s.add_dependency "rails-assets-jstimezonedetect", "~> 1.0.5"
  s.add_dependency "rails-assets-lodash", "~> 3.6.0"
  s.add_dependency "rails-assets-nprogress", "~> 0.1.6"
  s.add_dependency "rails-assets-momentjs", "~> 2.9.0"
  s.add_dependency "rails-assets-pikaday", "~> 1.3.2"
  s.add_dependency "rails-assets-react-radio-group", "~> 0.1.2"
  s.add_dependency "rails-assets-select2", "~> 3.5.2"
  s.add_dependency "rails-assets-selectivizr", "~> 1.0.2"
  s.add_dependency "rails-assets-speakingurl", "~> 1.1.1"
  s.add_dependency "rails-assets-viewloader", "~> 2.1.0"

  # Admin user auth
  s.add_dependency "devise", "~> 3.5.1"
end
