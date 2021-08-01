# frozen_string_literal: true

# == Schema Information
#
# Table name: metadata_types
#
#  id         :integer          not null, primary key
#  value      :string
#  created_at :datetime
#  updated_at :datetime
#
class MetadataType < ApplicationRecord
  has_many :metadata
  # validates_uniqueness_of :value, :scope => :user_id

  # @@ACOUSTID_FINGERPRINT = MetadataType.find_or_create_by!(:value => "AcoustID Fingerprint")
  # ACOUSTID_FINGERPRINT = @@ACOUSTID_FINGERPRINT
end
