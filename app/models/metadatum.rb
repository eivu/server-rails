class Metadatum < ApplicationRecord
  belongs_to :user
  belongs_to :metadata_type
end
