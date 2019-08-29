class CloudFileUploaderJob < ApplicationJob

  queue_as :default

  def perform(*args)
    puts :now
    # Do something later
    Bucket.determine(bucket)
    CloudFile.ingest(path_to_item, bucket, options)


    cloud_file = CloudFile.upload path_to_file, bucket, options
    tagger = Tagger::Factory.generate(cloud_file)
    tagger.identify_and_update!
    cloud_file
  end

  class << self
    def construct_file_info(path_to_file)
      # get metadata
      file      = File.open(path_to_file)
      mime      = MimeMagic.by_magic(file)
      md5       = Digest::MD5.file(path_to_file).hexdigest.upcase

      # needed to construct remote s3 path
      flags     = Tagger::Base.set_flags_via_path(path_to_file)
      if flags[:peepy].present?
        mediatype = "peepshow"
      else 
        mediatype = mime.mediatype
      end


      store_dir = "#{mediatype}/#{md5.scan(/.{2}|.+/).join("/")}"
      sanitized_filename = CloudFile.sanitize(filename)

      {
        remote_path: "#{store_dir}/#{sanitized_filename}",
        filename: File.basename(path_to_file),
        md5: md5,
        filesize: file.size,
        mime_type: mime.type,
      }
    end
  end


  def upload(path_to_file, bucket, options={})
    ActiveRecord::Base.transaction do
      # fetch bucket
      bucket    = Bucket.determine(bucket)
      folder    = Folder.determine(options[:folder_id]) || Folder.create_from_path(path_to_file)
      file_info = CloudFileUploaderJob.construct_file_info(path_to_file)


      # audio files can be duplicated
      raise "File already exists (id: #{old_id})" if CloudFile.exists?(md5: file_info[:mime_type], bucket: bucket, folder: folder)

      #upload file and create cloud file object
      obj = bucket.create_object(file_info[:remote_path])
      obj.upload_file(path_to_file, :acl => 'public-read', :content_type => file_info[:mime_type], :metadata => {})
      cloud_file = CloudFile.create! :bucket_id => bucket.id, :folder => folder,
                                      :md5 => file_info[:md5], :filesize => file_info[:filesize], :name => file_info[:filename], :content_type => filesize[:mime_type],
                                      :asset => file_info[:sanitized_filename], :path_to_file => path_to_file, :user_id => bucket.user_id,
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
