#Fog.credentials_path = Rails.root.join('config/fog.yml')


if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :aws

    config.enable_processing = true

  config.aws_credentials = {
    access_key_id:     AWS_CONFIG[:access_key_id],
    secret_access_key: AWS_CONFIG[:secret_access_key]
  }


    config.aws_bucket  = 'eivu'
    config.aws_acl    = :public_read
    # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end