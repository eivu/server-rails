class TreeSerializer

  def initialize(object)
    case object.class.name
    when "Folder"
      key = object
      folder
    when "nil"
      objects = Folder.roots.collect do |folder|

      end
      objects += CloudFile.where(:folder_id => nil).collect{|cf| cf.attributes.merge("entry_type" => "file")}
      objects 
    else
      raise "Unkown case for TreeSerializer#initialize with #{object.class}"
    end
    object
  end
end