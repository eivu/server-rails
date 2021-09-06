# frozen_string_literal: true

FactoryBot.define do
  factory :cloud_file do
    trait :reserved do
      md5 { Faker::Crypto.md5 }
      bucket_id { rand(1..10) }
      state { 'reserved' }
    end

    trait :transfered do
      reserved
      content_type { Faker::File.mime_type }
      asset { "#{Faker::Lorem.word.downcase}.#{content_type.split('/').last.gsub('+', '.')}" }
      filesize { rand(100.kilobytes..2.gigabytes) }
      state { 'transfered' }
    end

    trait :audio do
      content_type { 'audio/mpeg' }
      asset { "#{Faker::Lorem.word.downcase}.mp3" }
    end
  end
end
