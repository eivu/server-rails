class PopulateCloudFilesCountInFolders < ActiveRecord::Migration[5.2]
  def up
    Folder.unscoped.all.each do |f|
      count = CloudFile.unscoped.where(folder_id: f.id).count
      Folder.where(id: f.id).update_all(cloud_files_count: count)
      puts "set #{f.name}(#{f.id}) => #{count}"
    end
  end

  def down
  end
end
