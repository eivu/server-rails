class Tag < ApplicationRecord
  belongs_to :user
  has_many :cloud_file_taggings
  has_many :cloud_files, :through => :cloud_file_taggings
  validates_uniqueness_of :value, :scope => :user_id
end
