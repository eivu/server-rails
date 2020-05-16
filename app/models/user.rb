class User < ApplicationRecord
  has_secure_token
  has_one_time_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # #uses attr_encrypted to prevent access_key_id and secret_access_key from being stored in the db as plain text
  # attr_encrypted :access_key_id, :key => SECURITY_KEY, :mode => :per_attribute_iv_and_salt
  # attr_encrypted :secret_access_key, :key => SECURITY_KEY, :mode => :per_attribute_iv_and_salt

  has_many :buckets
  has_many :cloud_files, :through => :buckets
  has_many :folders, :through => :buckets


  def s3_credentials
    @s3_credentials ||= Aws::Credentials.new(self.access_key_id, self.secret_access_key)
  end

  def s3_client
    @client ||= Aws::S3::Client.new(
      :region => 'us-east-1',
      :credentials => s3_credentials
    ) 
  end

  def otp_uri
    provisioning_uri(Rails.application.class.name)
  end

  def otp_qr_code
    QrcodeGenerator.uri_as_svg(otp_uri)
  end

  ############################################################################
  private
  ############################################################################

end
