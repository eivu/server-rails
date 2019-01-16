class ArtistRelease < ApplicationRecord
  belongs_to :artist, :counter_cache => :releases_count
  belongs_to :release
end
