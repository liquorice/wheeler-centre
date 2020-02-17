FactoryGirl.define do
  factory :site, class: Heracles::Site do
    title "Icelab School of Ruby"
    sequence(:slug) { |n| "icelab-sor-#{n}" }
    origin_hostnames %w{icelab.com.au}
    published true
    preview_token "abc"
  end
end
