# == Schema Information
#
# Table name: buckets
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  region_id  :integer
#  created_at :datetime
#  updated_at :datetime
#
class Bucket < ApplicationRecord
  include UuidSeekable
  belongs_to :user#, :inverse_of => :bucket
  belongs_to :region
  has_many :cloud_files
  has_uuid
  after_initialize :set_uuid

  validates :uuid, presence: true, uniqueness: true

  def create_object(path)
    resource.bucket(name).object(path)
  end

  ############################################################################
  private
  ############################################################################
  def resource
    @resource ||= Aws::S3::Resource.new(
                      :credentials => self.user.s3_credentials,
                      :region => 'us-east-1'
                    )
  end
end
