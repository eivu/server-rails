class CloudFileTagging < ActiveRecord::Base
  belongs_to :cloud_file, :inverse_of => :taggings
  belongs_to :tag, :inverse_of => :cloud_file_taggings
  validates_uniqueness_of :tag_id, :scope => :cloud_file_id
end
