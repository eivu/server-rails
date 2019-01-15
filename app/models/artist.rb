class Artist < ApplicationRecord
  has_many :artist_releases
  has_many :releases, :through => :artist_releases, :counter_cache => true
  has_many :cloud_files, :through => :releases, :counter_cache => true
  has_many :audio_files, :through => :releases, :counter_cache => true
  has_many :peep_files, :through => :releases, :counter_cache => true
end
