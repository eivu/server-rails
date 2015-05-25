class Folder < ActiveRecord::Base
  # acts_as_tree order: "name"
  has_ancestry

  belongs_to :bucket
  has_many :cloud_files

  validates_uniqueness_of :name, :scope => :ancestry

  @@bucket = nil
  @@ignore = nil
  #making it a set so duplicates won't be stored
  @@errors = Set.new


  class << self
    def create_from_path(path_to_file)
      #save file in "root" of folder if ignore is blank
      return nil if @@ignore.blank?
      @folder = @parent = nil
      path_name = Pathname.new(path_to_file.gsub(@@ignore,""))
      path_name.dirname.to_s.split("/").each do |folder_name|
        @folder   = Folder.where(:name => folder_name.to_s, :ancestry => @parent.try(:path_ids).try(:join, "/")).first_or_create!
        @parent   = @folder
      end
      @folder
    end


    def upload(path_to_dir, bucket, options={})
      bucket = @@bucket || Bucket.determine(bucket)
      Folder.traverse(path_to_dir) do |path_to_item|
        puts "=== UPLOADING #{path_to_item.gsub(@@ignore,"")}"
        CloudFile.upload(path_to_item, bucket, options)
      end
    end


    def upload!(path_to_dir, bucket, options={})
      Folder.upload(path_to_dir, bucket, options.merge(:prune => true))
    end


    def clean!(path_to_dir, bucket)
      bucket = Bucket.determine(bucket)
      Folder.traverse(path_to_dir) do |path_to_item|
        md5  = Digest::MD5.file(path_to_item).hexdigest.upcase
        cloud_file = CloudFile.where(:md5 => md5, :bucket_id => bucket.id).first
        if cloud_file.present? && CloudFile.online?(cloud_file.url)
          puts "=== DELETING #{path_to_item.gsub(@@ignore,"")}"
          FileUtils.rm(path_to_item) 
        else
          puts ... SKIPPING #{path_to_item.gsub(@@ignore,"")}"
        end
      end
    end


    #updates the folders that videos are in
    def update_tree(path_to_dir)
      Folder.traverse(path_to_dir) do |path_to_item|
        puts "=== UPDATING #{path_to_item.gsub(@@ignore,"")}"
        folder = Folder.create_from_path(path_to_item)
        CloudFile.find_by_md5(Digest::MD5.file(path_to_item).hexdigest.upcase).update_attributes! :folder_id => folder.id
      end
    end


    #traverse the tree and upload every file
    def traverse(path_to_dir)
      @@ignore = path_to_dir.strip
      @@ignore += "/" unless @@ignore.ends_with?("/")
      #grab all folders in the dir
      Dir.glob("#{path_to_dir}/**/*").each do |path_to_item|
        next if path_to_item.starts_with?(".") || File.directory?(path_to_item)
        begin
          yield path_to_item
        rescue Exception => error
          unless error.message == "Validation failed: Md5 has already been taken"
            puts "  skipping (#{error})"
            @@errors << { error.message => path_to_item }
          end
        end
      end
      nil
    end

    def errors
      @@errors
    end
  end
end