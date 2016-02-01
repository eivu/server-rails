class Metadatum < ActiveRecord::Base
  belongs_to :user, :inverse_of => :metadata
  belongs_to :metadata_type, :inverse_of => :metadata
  has_many :metadata_instances, :inverse_of => :metadatum

  validates_uniqueness_of :value, :scope => [:user_id, :metadata_type_id]
  validates_presence_of :value, :user_id, :metadata_type_id
end
