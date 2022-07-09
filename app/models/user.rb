# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                               :integer          not null, primary key
#  username                         :string
#  created_at                       :datetime
#  updated_at                       :datetime
#  email                            :string           default(""), not null
#  encrypted_password               :string           default(""), not null
#  reset_password_token             :string
#  reset_password_sent_at           :datetime
#  remember_created_at              :datetime
#  sign_in_count                    :integer          default(0), not null
#  current_sign_in_at               :datetime
#  last_sign_in_at                  :datetime
#  current_sign_in_ip               :inet
#  last_sign_in_ip                  :inet
#  confirmation_token               :string
#  confirmed_at                     :datetime
#  confirmation_sent_at             :datetime
#  unconfirmed_email                :string
#  encrypted_access_key_id          :string
#  encrypted_access_key_id_salt     :string
#  encrypted_access_key_id_iv       :string
#  encrypted_secret_access_key      :string
#  encrypted_secret_access_key_salt :string
#  encrypted_secret_access_key_iv   :string
#  token                            :string
#  otp_secret_key                   :string
#
class User < ApplicationRecord
  # has_secure_token
  include UuidSeekable
  has_one_time_password
  has_uuid
  after_initialize :set_uuid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  encrypts :access_key_id
  encrypts :secret_access_key

  has_many :buckets
  has_many :cloud_files, through: :buckets
  has_many :folders, through: :buckets
  # has_many :metataggings, dependent: :destroy, autosave: true
  has_many :metadata#, through: :metataggings, dependent: :destroy, autosave: true

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
