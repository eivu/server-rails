class Metadatum < ActiveRecord::Base
  belongs_to :user
  belongs_to :metadata_type
end
