class Folder < ActiveRecord::Base
  # acts_as_tree order: "name"
  has_ancestry

  has_many :cloud_files

  validates_uniqueness_of :name, :scope => :parent_id

  @@ignore = nil
  #making it a set so duplicates won't be stored
  @@errors = Set.new



# reload!;Folder.upload! "/Users/jinx/Desktop/pronz"

  class << self
    def create_from_path(path_to_file)
      @folder = @parent = nil
      path_name = Pathname.new(path_to_file.gsub(@@ignore,""))
      path_name.dirname.to_s.split("/").each do |folder_name|
        @folder   = Folder.where(:name => folder_name.to_s, :parent_id => @parent.try(:id)).first_or_create!
        @parent   = @folder
      end
      @folder
    end


    def upload(path_to_dir, purge=false)
      Folder.traverse(path_to_dir, purge) do |path_to_item|
        puts "=== UPLOADING #{path_to_item.gsub(@@ignore,"")}"
        CloudFile.upload!(path_to_item)
      end
    end


    def upload!(path_to_dir)
      Folder.upload(path_to_dir, true)
    end


    def clean!(path_to_dir)
      Folder.traverse(path_to_dir, true) do |path_to_item|
        1#we just need to pass in purge=true to Folder.traverse
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


    def traverse(path_to_dir, purge=false)
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
        #clear cached files immediately
        CarrierWave.clean_cached_files!
        CloudFile.verify_and_delete!(path_to_item) if purge
      end
      nil
    end

    def errors
      @@errors
    end
  end
end
