class Release < ApplicationRecord
  belongs_to :release_type

  has_many :cloud_files, :counter_cache => true
  has_many :artist_releases
  has_many :artists, :through => :artist_releases
end
