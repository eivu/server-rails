# == Schema Information
#
# Table name: artists
#
#  id                :integer          not null, primary key
#  name              :string
#  ext_id            :string
#  data_source_id    :integer
#  cloud_files_count :integer          default(0), not null
#  releases_count    :integer          default(0), not null
#  video_files_count :integer          default(0), not null
#  audio_files_count :integer          default(0), not null
#  peep_files_count  :integer          default(0), not null
#  misc_files_count  :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Artist < ApplicationRecord
  include Reactable
  include ConfigureAndSavable
  has_many :artist_releases, :dependent => :destroy
  has_many :releases, :through => :artist_releases

  has_many :artist_cloud_files
  has_many :cloud_files, :through => :artist_cloud_files

end
