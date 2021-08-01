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
end
