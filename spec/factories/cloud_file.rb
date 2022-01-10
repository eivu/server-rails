# frozen_string_literal: true

FactoryBot.define do
  factory :cloud_file do
    user { create :user }

    trait :reserved do
      md5 { Faker::Crypto.md5 }
      bucket_id { rand(1..10) }
      state { 'reserved' }
    end

    trait :transfered do
      reserved
      content_type { Faker::File.mime_type }
      asset { "#{Faker::Lorem.word.downcase}.#{Faker::File.extension}" }
      filesize { rand(100.kilobytes..2.gigabytes) }
      state { 'transfered' }
    end

    trait :completed do
      transfered
      state { 'completed' }
    end

    trait :audio do
      content_type { 'audio/mpeg' }
      filesize { rand(750.kilobytes..10.megabytes) }
      asset { "#{Faker::Lorem.word.downcase}.mp3" }
    end
  end
end
