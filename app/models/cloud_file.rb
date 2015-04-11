class CloudFile < ActiveRecord::Base
  mount_uploader :asset, CloudFileUploader

  belongs_to :folder

  validates_uniqueness_of :md5

  def visit
    system "open #{self.asset.url}"
  end

  class << self
    def upload!(path_to_file)
      ActiveRecord::Base.transaction do
        cloud_file = CloudFile.new :folder => Folder.create_from_path(path_to_file)
        File.open(path_to_file) do |file|
          cloud_file.asset = file
        end
        cloud_file.save!
      end
    end

    def verify_and_delete!(path_to_file)
      puts "    verifying & cleaning....."
      md5 = Digest::MD5.file(path_to_file).hexdigest
      FileUtils.rm(path_to_item) if CloudFile.where(:md5 => md5).present?
    end
  end
end
