class CloudFileUploaderService

  def upload(path_to_file, bucket, options={})
    ActiveRecord::Base.transaction do
      # fetch bucket
      bucket    = Bucket.ensure(bucket)
      folder    = Folder.ensure(options[:folder_id]) || Folder.create_from_path(path_to_file)
      file_info = FileInfoService.inspect(path_to_file)

      # audio files can be duplicated
      raise "File already exists (id: #{old_id})" if CloudFile.exists?(md5: file_info[:mime_type], bucket: bucket, folder: folder)

      #upload file and create cloud file object
      obj = bucket.create_object(file_info[:remote_path])
      obj.upload_file(path_to_file, :acl => 'public-read', :content_type => file_info[:mime_type], :metadata => {})
      cloud_file = CloudFile.create! :bucket_id => bucket.id, :folder => folder,
                                      :md5 => file_info[:md5], :filesize => file_info[:filesize], :name => file_info[:filename], :content_type => filesize[:mime_type],
                                      :asset => file_info[:sanitized_filename], :path_to_file => path_to_file, :user_id => bucket.user_id,
                                      :release_id => options[:release_id] #, :rating => CloudFile.ensure_rating(path_to_file),
      #remove file if prune is true
      if options[:prune] == true
        if CloudFile.online?(cloud_file.url)
          FileUtils.rm(path_to_file) 
        else
          raise "file not online"
        end
      end

      #clear cached files immediately
      cloud_file
    end    
  end
end
