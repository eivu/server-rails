class MetadataType < ActiveRecord::Base
  has_many :metadata
  validates_uniqueness_of :value, :scope => :user_id
end
