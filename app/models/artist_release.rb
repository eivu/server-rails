# frozen_string_literal: true

# == Schema Information
#
# Table name: artist_releases
#
#  id              :integer          not null, primary key
#  artist_id       :integer
#  release_id      :integer
#  relationship_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ArtistRelease < ApplicationRecord
  belongs_to :artist, counter_cache: :releases_count
  belongs_to :release
end
