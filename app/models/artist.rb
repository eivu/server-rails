class Artist < ApplicationRecord
  include ConfigureAndSavable
  has_many :artist_releases, :dependent => :destroy
  has_many :releases, :through => :artist_releases

  has_many :artist_cloud_files
  has_many :cloud_files, :through => :artist_cloud_files

end
