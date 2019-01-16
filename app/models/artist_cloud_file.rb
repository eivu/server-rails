class ArtistCloudFile < ApplicationRecord
  belongs_to :artist
  belongs_to :cloud_file

  after_create  :increment_counts
  after_destroy :decrement_counts

  ################
  private
  ################

  def increment_counts
    sql = [
      "UPDATE artists SET cloud_files_count = cloud_files_count + 1 WHERE id = #{self.artist_id}",
      "UPDATE artists SET #{resource_count} = #{resource_count} + 1 WHERE id = #{self.artist_id}"
    ].join(";")
    ActiveRecord::Base.connection.execute(sql)
  end

  def decrement_counts
    sql = [
      "UPDATE artists SET cloud_files_count = cloud_files_count - 1 WHERE id = #{self.artist_id}",
      "UPDATE artists SET #{resource_count} = #{resource_count} - 1 WHERE id = #{self.artist_id}"
    ].join(";")
    ActiveRecord::Base.connection.execute(sql)
  end

  def resource_count
    if self.cloud_file.peepy?
      "peep_files_count"
    elsif self.cloud_file.content_type.starts_with?("audio")
      "audio_files_count"
    elsif self.cloud_file.content_type.starts_with?("video")
      "video_files_count"
    else
      "misc_files_count"
    end
  end



end
