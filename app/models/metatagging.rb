class Metatagging < ActiveRecord::Base
  belongs_to :cloud_file, :inverse_of => :metagggings
  belongs_to :metadatum, :inverse_of => :metagggings

  def value=(string)
    user = self.cloud_file.user
    raise "Assignment impossible if cloud_file undefined" if user.blank?
    self.metadatum_id = Metadata.find_or_create_by!(:value => string)
  end
end
