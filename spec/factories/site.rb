require 'securerandom'

FactoryBot.define do
    factory :site, class: 'Heracles::Site' do
      id { SecureRandom.uuid }
      title { 'Wheeler Centre' }
      slug { 'wheeler-centre' }
      published { true }
      origin_hostnames { "localhost" }
      edge_hostnames { "localhost" }
    end
  end
  