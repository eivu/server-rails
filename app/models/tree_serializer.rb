class TreeSerializer

  def self.build(object=nil, depth=2)
    return nil if depth == 0
    if object.present?
      base_hash = object.try(:attributes) || {}
      klass = object.class.name.underscore
      object_attr = base_hash.merge("klass" => klass, "vue_id" => "#{klass}_#{object.id}")
    end
    case object.class.name
    when "CloudFile"
      tree = object_attr.merge("entry_type" => "file", "url" => object.url)
    when "Folder"
      sub_folders = object.children.order(:name).collect {|sub_folder| TreeSerializer.build(sub_folder, depth - 1)}.compact

      cloud_files = object.cloud_files.order(:name).collect {|cloud_file| TreeSerializer.build(cloud_file, depth - 1)}.compact
      tree = object_attr.merge("entry_type" => "grouping", "klass" => object.class.name.underscore, "children" => (sub_folders + cloud_files))
    when "NilClass"
      folders = Folder.roots.collect {|folder| TreeSerializer.build(folder,depth - 1)}
      cloud_files = CloudFile.where(:folder_id => nil).order(:name).collect {|cloud_file| TreeSerializer.build(cloud_file, depth - 1)}.compact
      tree = folders + cloud_files
    else
      raise "Unkown case for TreeSerializer#initialize with #{object.class}"
    end
    tree
  end
end

