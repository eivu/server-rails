class ArtistCloudFile < ApplicationRecord
  belongs_to :artist
  belongs_to :cloud_file
end
