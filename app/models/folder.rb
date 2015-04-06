class Folder < ActiveRecord::Base
  acts_as_tree order: "name"

  has_many :cloud_files

  validates_uniqueness_of :name, :scope => :parent_id

  @@ignore = nil

  def self.create_from_path(path_to_file)
    @folder = @parent = nil
    path_name = Pathname.new(path_to_file.gsub(@@ignore,""))
    path_name.dirname.to_s.split("/").each do |folder_name|
      @folder   = Folder.where(:name => folder_name.to_s, :parent_id => @parent.try(:id)).first_or_create!
      @parent   = @folder
    end
    @folder
  end


  def self.upload(path_to_dir="/Users/jinx/Desktop/pronz")
    @@ignore = path_to_dir.strip
    @@ignore += "/" unless @@ignore.ends_with?("/")
    #grab all folders in the dir
    Dir.glob("#{path_to_dir}/**/*").each do |path_to_item|
      next if File.directory?(path_to_item)
      begin
        puts "=== UPLOADING #{path_to_item.gsub(@@ignore,"")}"
        CloudFile.upload!(path_to_item)
        #clear cached files immediately
        CarrierWave.clean_cached_files!
      rescue Exception => error
        puts "  skipping (#{error})"
      end
    end
    nil
  end


  def self.update_tree(path_to_dir)
    @@ignore = path_to_dir.strip
    @@ignore += "/" unless @@ignore.ends_with?("/")
    #grab all folders in the dir
    Dir.glob("#{path_to_dir}/**/*").each do |path_to_item|
      next if path_to_item.starts_with?(".") || File.directory?(path_to_item)
      begin
        puts "=== UPDATING #{path_to_item.gsub(@@ignore,"")}"
        folder = Folder.create_from_path(path_to_item)
        CloudFile.find_by_md5(Digest::MD5.file(path_to_item).hexdigest.upcase).update_attributes! :folder_id => folder.id
      rescue Exception => error
        puts "  skipping (#{error})"
      end
    end
    nil
  end  
end
