module CloudFilesHelper

  def view_content(cloud_file)
    render partial: "cloud_files/formats/#{cloud_file.media_type}"
  end
end
