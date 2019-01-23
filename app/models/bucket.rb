class Bucket < ActiveRecord::Base
  include Determinable
  belongs_to :user#, :inverse_of => :bucket
  belongs_to :region
  has_many :cloud_files


  class << self
    # test function
    def test_file
      Bucket.last.cloud_files.last
    end

    def redo
      # Bucket.last.cloud_files.where("created_at >  '2016-01-01'").destroy_all
      # Artist.where("created_at >  '2016-01-01'").destroy_all
      Release.where("id > 100").destroy_all
      Folder.where("id > 529").destroy_all
      CloudFile.where("id > 2000").destroy_all
      Folder.test_load
    end
  end


  def create_object(path)
    resource.bucket(self.name).object(path)
  end


  ############################################################################
  private
  ############################################################################

  def resource
    @s3_resource ||= Aws::S3::Resource.new(
                      :credentials => self.user.s3_credentials,
                      :region => 'us-east-1'
                    )
  end



end
