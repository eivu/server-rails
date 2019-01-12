class Bucket < ActiveRecord::Base
  belongs_to :user#, :inverse_of => :bucket
  belongs_to :region
  has_many :cloud_files


  class << self
    def determine(obj)
      if obj.kind_of?(Bucket)
        obj
      #is obj a number in quotes
      elsif obj.to_i.to_s == obj.to_s
        Bucket.find(obj)  
      elsif Bucket.kind_of?(String)
        Bucket.find_by_name(obj)
      else
        raise "Bucket not found with id (#{id})"
      end
    end

    # test function
    def test_file
      Bucket.last.cloud_files.last
    end

    def redo
      Bucket.test_file.destroy
      Folder.upload "/Users/jinx/Dropbox/eivu/sample", 2
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
