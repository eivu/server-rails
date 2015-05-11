class CFU

  def self.foo
    # s3 = Aws::S3::Resource.new(:region => AWS_CONFIG[:region])
    # obj = s3.bucket('bucket-name').object('key')
    # obj.upload_file('/path/to/source/file')




    begin
      s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(AWS_CONFIG[:access_key_id], AWS_CONFIG[:secret_access_key]),
        region: AWS_CONFIG[:region]
      )
      

      path_to_file = '/Users/jinx/Desktop/regular show - RingToneSong.mp3'

      file_object = File.read(path_to_file)


File.size 

      md5 = Digest::MD5.hexdigest(file_object)


      obj = s3.bucket("eivutest").object("test1")
      obj.upload_file(path, :acl => 'public-read')
      obj.public_url

      CloudFile.create!
    end




  end

end