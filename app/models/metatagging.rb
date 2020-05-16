class Metatagging < ApplicationRecord
  belongs_to :cloud_file
  belongs_to :metadatum

  def value=(string)
    user = self.cloud_file.user
    raise "Assignment impossible if cloud_file undefined" if user.blank?
    self.metadatum = Metadatum.find_or_create_by!(:value => string)
  end
end
