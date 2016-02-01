class MetadataType < ActiveRecord::Base
  has_many :metadata, :inverse_of => :metadata_type
  validates_uniqueness_of :value
end
