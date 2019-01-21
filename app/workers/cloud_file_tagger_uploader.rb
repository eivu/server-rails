class CloudFileTaggerUploader

  @queue = :uploads


  class << self

    def perform(path_to_file, bucket, options={})
      CloudFileTaggerUploader.upload(path_to_file, bucket, options)
    end

    def upload(path_to_file, bucket, options={})
      ActiveRecord::Base.transaction do
        #fetch bucket
        bucket    = Bucket.determine(bucket)

        #get metadata
        file      = File.open(path_to_file)
        mime      = MimeMagic.by_magic(file)
        md5       = Digest::MD5.file(path_to_file).hexdigest.upcase
        
        store_dir = "#{mime.mediatype}/#{md5.scan(/.{2}|.+/).join("/")}"
        filename  = File.basename(path_to_file)
        sanitized_filename = CloudFile.sanitize(filename)
        folder    = Folder.determine(options[:folder]) || Folder.create_from_path(path_to_file)

        #test if file already exists
        old_id = CloudFile.where(:md5 => md5, :bucket_id => bucket.id).first.try(:id)
        raise "File already exists (id: #{old_id})" if old_id.present?

        #upload file and create cloud file object
        obj = bucket.create_object("#{store_dir}/#{sanitized_filename}")
        obj.upload_file(path_to_file, :acl => 'public-read', :content_type => mime.type, :metadata => {})
        cloud_file = CloudFile.create! :bucket_id => bucket.id, :folder => folder,
                                        :md5 => md5, :filesize => file.size, :name => filename, :content_type => mime.type,
                                        :asset => sanitized_filename, :path_to_file => path_to_file, :user_id => bucket.user_id,
                                        :release_id => options[:release_id] #, :rating => CloudFile.determine_rating(path_to_file),
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
end