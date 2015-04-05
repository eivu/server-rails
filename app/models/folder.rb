class Folder < ActiveRecord::Base
  acts_as_tree order: "name"

  has_many :cloud_files

  @@ignore = nil

  def self.create_from_path(path_to_file)
    path_name = Pathname.new(path_to_file.gsub(@@ignore,""))
    path_name.dirname.split.each do |folder_name|
      @folder   = Folder.where(:name => folder_name.to_s, :parent_id => @parent.try(:id)).first_or_create!
      @parent   = @folder
    end
    @folder
  end


  def self.upload(path_to_dir)
    @@ignore = path_to_dir
    @@ignore += "/" unless @@ignore.ends_with?("/")
    #grab all folders in the dir
    Dir.glob("#{path_to_dir}/**/*").each do |path_to_item|
      # dir_name = '/Users/jinx/Desktop/pronz/ds_bdsm/'
      next if File.directory?(path_to_item)
      begin
        puts "=== UPLOADING #{path_to_item.gsub(@@ignore,"")}"
        CloudFile.upload!(path_to_item)
      rescue Exception => error
        puts "  skipping (#{error})"
      end
    end
    nil
  end
end
