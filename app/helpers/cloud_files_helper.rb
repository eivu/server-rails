module CloudFilesHelper

  def view_content(cloud_file)
    if cloud_file.content_type&.include?('audio')
      render partial: "cloud_files/formats/audio"
    else
      template_name = cloud_file.content_type.gsub('/', '_')
      render partial: "cloud_files/formats/#{template_name}"
    end
  end
end
