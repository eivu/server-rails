# AWS_CONFIG = YAML.load_file(Rails.root + 'config/aws.yml')[Rails.env].with_indifferent_access
AWS_CONFIG = 
  { 
    :region => 'us-east-1',
    :access_key_id => ENV["EIVU_AWS_ACCESS_KEY_ID"],
    :secret_access_key => ENV["EIVU_AWS_SECRET_ACCESS_KEY"],
    :bucket => 'eivutest'
  }