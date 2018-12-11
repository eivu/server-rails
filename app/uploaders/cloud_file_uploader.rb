# encoding: utf-8
#erquire 'carrierwave/processing/mime_types'

class CloudFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  # include CarrierWave::MagicMimeTypes

  storage :aws

  process :set_content_type, :fix_mime, :set_model_properties
  


  def md5
    if model.md5.present?
      model.md5
    else
      chunk = model.send(mounted_as)
      @md5 ||= Digest::MD5.hexdigest(chunk.read.to_s).upcase
    end
  end


  def store_dir
    self.md5.scan(/.{2}|.+/).join("/")
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  ################################################################################
  protected
  ################################################################################

  def set_model_properties
    model.content_type = self.file.content_type
    model.md5 = self.md5
    #mark the file has havinb 5 stars if it begins with a '_' was rob's personal convention (would make it appear at top of folder)
    model.rating = 5 if Pathname.new(self.file.file).basename.to_s.starts_with?("_")
    model.rating = 4.5 if Pathname.new(self.file.file).basename.to_s.starts_with?("`")
    model.filesize = self.file.size
  end

  def fix_mime
    self.file.content_type =
      case self.file.content_type
      when "application/mp4"
        "video/mp4"
      else
        self.file.content_type
      end
  end

end
