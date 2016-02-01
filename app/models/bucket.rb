class Bucket < ActiveRecord::Base
  belongs_to :user, :inverse_of => :buckets
  belongs_to :region, :inverse_of => :buckets
  has_many :cloud_files, :inverse_of => :bucket
  has_many :folders, :inverse_of => :bucket


  def self.determine(obj)
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
