RSpec.configure do |config|
  # Include capybara matchers in view specs
  config.include Capybara::RSpecMatchers, :type => :view
end
