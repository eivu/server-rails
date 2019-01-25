class TreeSerializer

  def self.build(object=nil)
    base_hash = object.try(:attributes) || {}
    object_attr = base_hash.merge("klass" => object.class.name)
    case object.class.name
    when "CloudFile"
      tree = object_attr.merge("entry_type" => "file")
    when "Folder"
      sub_folders = object.children.collect {|sub_folder| TreeSerializer.build(sub_folder)}
      cloud_files = object.children.collect {|cloud_file| TreeSerializer.build(cloud_file)}
      tree = object_attr.merge("entry_type" => "grouping", "klass" => object.class.name, "children" => (sub_folders + cloud_files))
    when "NilClass"
      folders = Folder.roots.collect {|folder| TreeSerializer.build(folder)}
      cloud_files = CloudFile.where(:folder_id => nil).collect {|cloud_file| TreeSerializer.build(cloud_file)}
      tree = folders + cloud_files
    else
      raise "Unkown case for TreeSerializer#initialize with #{object.class}"
    end
    tree
  end
end

