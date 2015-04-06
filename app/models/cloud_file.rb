class CloudFile < ActiveRecord::Base
  mount_uploader :asset, CloudFileUploader

  belongs_to :folder

  validates_uniqueness_of :md5

  def visit
    system "open #{self.asset.url}"
  end

  def self.upload!(path_to_file)
    # md5 = Digest::MD5.hexdigest(File.read('path_to_file'))
    ActiveRecord::Base.transaction do
      cloud_file = CloudFile.new :folder => Folder.create_from_path(path_to_file)
      File.open(path_to_file) do |file|
        cloud_file.asset = file
      end
      cloud_file.save!
    end
  end
end
