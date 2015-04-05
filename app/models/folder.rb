class Folder < ActiveRecord::Base
  acts_as_tree order: "name"

  has_many :cloud_files

  IGNORE = "/Users/jinx/Desktop/pronz/"

  def self.create_from_path(path_to_file)
    path_name = Pathname.new(path_to_file.gsub(IGNORE,""))
    path_name.dirname.split.each do |folder_name|
      @folder   = Folder.where(:name => folder_name.to_s, :parent_id => @parent.try(:id)).first_or_create!
      @parent   = @folder
    end
    @folder
  end
end
