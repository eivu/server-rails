FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    token { Faker::Crypto.sha1 }
    password { Faker::Internet.password }
    confirmation_token { Devise.friendly_token }
    confirmation_sent_at { 3.days.ago }
    confirmed_at { Time.current }
  end
end
