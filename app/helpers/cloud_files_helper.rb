module CloudFilesHelper

  def view_content(cloud_file)
    template_name = cloud_file.content_type.gsub('/', '_')
    render partial: "cloud_files/formats/#{template_name}"
  end
end
