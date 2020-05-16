class CloudFileTagging < ApplicationRecord
  belongs_to :cloud_file
  belongs_to :tag
  validates_uniqueness_of :tag_id, :scope => :cloud_file_id
end
