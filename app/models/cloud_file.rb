class CloudFile < ActiveRecord::Base
  mount_uploader :asset, CloudFileUploader

  before_save :set_content_type, :set_md5, :set_size
  validates_uniqueness_of :md5


  def self.upload!(path_to_file)
    # md5 = Digest::MD5.hexdigest(File.read('path_to_file'))
    ActiveRecord::Base.transaction do
      cloud_file = CloudFile.new
      File.open(path_to_file) do |file|
        cloud_file.asset = file
      end
      cloud_file.save!
    end
  end

  ################################################################################
  protected
  ################################################################################

  def set_content_type
    self.content_type = self.asset.file.content_type
  end

  def set_md5
    self.md5 = self.asset.md5
  end

  def set_size
    self.filesize = self.asset.file.size
  end
end
