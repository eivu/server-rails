class Bucket < ActiveRecord::Base
  belongs_to :user
  belongs_to :region
  has_many :cloud_files, :through => :folders


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
end
