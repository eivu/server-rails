class Release < ApplicationRecord
  include Determinable
  belongs_to :release_type

  has_many :cloud_files, :dependent => :destroy, :counter_cache => :cloud_files_count
  has_many :artist_releases, :dependent => :destroy
  has_many :artists, :through => :artist_releases

end
