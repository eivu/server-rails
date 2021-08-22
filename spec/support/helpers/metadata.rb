# frozen_string_literal: true

module Helpers
  module Metadata
    def generate_artist_data
      rand(1..5).times.collect do
        { id: Faker::Crypto.sha1, name: Faker::Music::Hiphop.artist }
      end
    end

    def generate_recording_data
      artists = generate_artist_data
      {
        artist: artists,
        duration: rand(45..3000),
        id: Faker::Crypto.sha1,
        releasegroups: {
          artist: artists,
          id: Faker::Crypto.sha1,
          title: Faker::Music.album
        },
        title: Faker::Book.title
      }
    end
  end
end
