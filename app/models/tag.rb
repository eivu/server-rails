# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  value      :string
#  user_id    :integer
#  private    :boolean
#  created_at :datetime
#  updated_at :datetime
#
class Tag < ApplicationRecord
  belongs_to :user
  has_many :cloud_file_taggings
  has_many :cloud_files, through: :cloud_file_taggings
  validates_uniqueness_of :value, :scope => :user_id
end
