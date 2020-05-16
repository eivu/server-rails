# == Schema Information
#
# Table name: release_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ReleaseType < ApplicationRecord
  has_many :releases
end
