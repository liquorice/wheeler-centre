require 'securerandom'

FactoryBot.define do
  factory :home_page, class: "Heracles::Sites::WheelerCentre::HomePage" do
    id        { SecureRandom.uuid }
    slug      { "home" }
    title     { "Home" }
    url       { "home" }
    type      { "Heracles::Sites::WheelerCentre::HomePage" }
    published { true }
    hidden    { false }
    locked    { true }
  end
end
