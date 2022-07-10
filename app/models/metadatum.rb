# frozen_string_literal: true

# == Schema Information
#
# Table name: metadata
#
#  id               :integer          not null, primary key
#  value            :string
#  user_id          :integer
#  metadata_type_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#
class Metadatum < ApplicationRecord
  belongs_to :user
  belongs_to :type, class_name: 'MetadataType', foreign_key: 'metadata_type_id'
  belongs_to :metadata_type
  broadcasts_to ->(_) { 'metadata' } # Hotwire Implementation

  has_many :metataggings, dependent: :destroy, autosave: true
  has_many :cloud_files, through: :metataggings, dependent: :destroy, autosave: true

  scope(:alpha, -> { order('value') })
  scope(:with_types, -> { includes(:type).order('metadata_types.value, metadata.value') })
  scope(:peepy, -> { where(peepy: true) })
  scope(:human_readable, -> { where.not(metadata_type_id: [1,2,5,6,11]) })
  scope(:nsfw, -> { where(nsfw: true) })

  def toggle_expansion
    update! expanded: !expanded
  end
end
