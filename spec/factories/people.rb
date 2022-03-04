require 'securerandom'

FactoryBot.define do
  factory :people, class: 'Heracles::Sites::WheelerCentre::People' do
    id { SecureRandom.uuid }
    slug { 'people' }
    title { 'People' }
    url { 'people' }
    type { 'Heracles::Sites::WheelerCentre::People' }
    site
    published { true }
    hidden { false }
    locked { true }
  end
end