class MetadataInstance < ActiveRecord::Base
  belongs_to :cloud_file, :inverse_of => :metadata_instances
  belongs_to :metadatum, :inverse_of => :metadata_instances
end
