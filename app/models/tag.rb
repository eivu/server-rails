class Tag < ActiveRecord::Base
  belongs_to :user, :inverse_of => :tags
  has_many :cloud_file_taggings, :inverse_of => :tag
  has_many :cloud_files, :through => :cloud_file_taggings
  validates_uniqueness_of :value, :scope => :user_id
end
