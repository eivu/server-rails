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
  belongs_to :metadata_type

  scope(:alpha, -> { order('value') })
  scope(:peepy, -> { where(peepy: true) })
  scope(:human_readable, -> { where.not(metadata_type_id: [1,2,5,6,14]) })
  scope(:nsfw, -> { where(nsfw: true) })
end
