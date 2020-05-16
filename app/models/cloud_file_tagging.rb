# == Schema Information
#
# Table name: cloud_file_taggings
#
#  id            :integer          not null, primary key
#  cloud_file_id :integer
#  tag_id        :integer
#  created_at    :datetime
#  updated_at    :datetime
#
class CloudFileTagging < ApplicationRecord
  belongs_to :cloud_file
  belongs_to :tag
  validates_uniqueness_of :tag_id, :scope => :cloud_file_id
end
