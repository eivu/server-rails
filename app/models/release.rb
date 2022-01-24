# == Schema Information
#
# Table name: releases
#
#  id                :integer          not null, primary key
#  name              :string
#  ext_id            :string
#  data_source_id    :integer
#  cloud_files_count :integer          default(0), not null
#  release_type_id   :integer
#  bundle_pos        :integer          default(1)
#  peepy             :boolean          default(FALSE)
#  nsfw              :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Release < ApplicationRecord
  # include ConfigureAndSavable
  include Reactable

  belongs_to :release_type

  has_many :cloud_files, dependent: :destroy, counter_cache: :cloud_files_count
  has_many :artist_releases, dependent: :destroy
  has_many :artists, through: :artist_releases
end
