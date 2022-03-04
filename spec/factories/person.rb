require 'securerandom'

FactoryBot.define do
  factory :person, class: 'Heracles::Sites::WheelerCentre::Person' do
    id { SecureRandom.uuid }
    slug { 'john-doe' }
    title { "John Doe" }
    fields_data {
      { 
        "first_name": { "field_type": "text", "value": "John" },
        "last_name":  { "field_type": "text", "value": "Doe"}
      }
    }
    site
    type { "Heracles::Sites::WheelerCentre::Person" }
    template { nil }
    published { true }
    hidden { false }
    locked { false }
  end
end