class SetCloudFilesCountInMetadata < ActiveRecord::Migration[7.0]
  def up
    Metadatum.all.each do |datum|
      Metadatum.where(id: datum.id).update_all(cloud_files_count: datum.cloud_files.distinct.count)
    end
  end

  def down
    Metadatum.update_all(cloud_files_count: 0)
  end
end
