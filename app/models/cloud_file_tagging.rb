class CloudFileTagging < ActiveRecord::Base
  belongs_to :cloud_file
  belongs_to :tag
end
