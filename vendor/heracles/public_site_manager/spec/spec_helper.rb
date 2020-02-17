# Coverage must be enabled before the application is loaded.
if ENV["COVERAGE"]
  require "simplecov"

  # Writes the coverage stat to a file to be used by Cane.
  class SimpleCov::Formatter::QualityFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      File.open("coverage/covered_percent", "w") do |f|
        f.puts result.source_files.covered_percent.to_f
      end
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::QualityFormatter

  SimpleCov.start do
    add_filter "/spec/"
    add_filter "/config/"
    add_filter "/vendor/"
    add_group  "Models", "app/models"
    add_group  "Controllers", "app/controllers"
    add_group  "Helpers", "app/helpers"
    add_group  "Views", 'app/views'
    add_group  "Mailers", "app/mailers"
  end
end

ENGINE_ROOT = File.join(File.dirname(__FILE__), "../")

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require "rspec/rails"

# Ensure FactoryGirl can see the factories inside this engine's spec/ directory
FactoryGirl.definition_file_paths = [File.expand_path("../factories", __FILE__)]
FactoryGirl.find_definitions

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[File.join(ENGINE_ROOT, "spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Require the new expect() syntax.
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # See database_cleaner.rb for database cleanup details.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true

  # Run non-feature specs (shuffled) before feature specs.
  config.register_ordering(:global) do |items|
    features, others = items.partition { |g| g.metadata[:type] == :feature }
    others.shuffle + features
  end
end
