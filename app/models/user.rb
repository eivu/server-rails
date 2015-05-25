class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_encrypted :access_key_id, :key => 'a secret key', :mode => :per_attribute_iv_and_salt
  attr_encrypted :secret_access_key, :key => SECURITY_KEY, :mode => :per_attribute_iv_and_salt


  attr_accessor :ignore #a parameter that can be passed via a form 
end
