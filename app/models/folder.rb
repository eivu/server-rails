class Folder < ActiveRecord::Base
  acts_as_tree order: "name"

  has_many :cloud_files

  validates_uniqueness_of :name, :scope => :parent_id

  @@ignore = nil
  #making it a set so duplicates won't be stored
  @@errors = Set.new

# 2.0.0-p481 :030 > a = Pathname.new "/Users/jinx/Downloads/foo/eds\:9"
#  => #<Pathname:/Users/jinx/Downloads/foo/eds:9> 
# 2.0.0-p481 :031 > a.each_filename{|f| p f}


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


    def upload!(path_to_dir)
      Folder.traverse(path_to_dir) do |path_to_item|
        puts "=== UPLOADING #{path_to_item.gsub(@@ignore,"")}"
        CloudFile.upload!(path_to_item)
        #clear cached files immediately
        CarrierWave.clean_cached_files!
        CloudFile.verify_and_delete!(path_to_item)
      end
    end


    def clean!(path_to_dir)
      Folder.traverse(path_to_dir) do |path_to_item|
        CloudFile.verify_and_delete!(path_to_item)
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


    def traverse(path_to_dir)
      @@ignore = path_to_dir.strip
      @@ignore += "/" unless @@ignore.ends_with?("/")
      #grab all folders in the dir
      Dir.glob("#{path_to_dir}/**/*").each do |path_to_item|
        next if path_to_item.starts_with?(".") || File.directory?(path_to_item)
        begin
          @temp = path_to_item
          yield path_to_item
        rescue Exception => error
          puts "  skipping (#{error})"
          @@errors << @temp
          CloudFile.verify_and_delete!(@temp)
        end
      end
      nil
    end
  end
end
