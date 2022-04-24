FactoryBot.define do
  factory :bucket do
    user { create :user }
    name { Faker::Lorem.word.downcase }
    region_id { 1 }
    uuid { SecureRandom.uuid }
  end
end
