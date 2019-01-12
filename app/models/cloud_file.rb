class CloudFile < ActiveRecord::Base

  belongs_to :folder
  belongs_to :bucket#, :inverse_of => :cloud_file
  has_one :user, :through => :bucket
  has_many :metataggings#, :dependent => :destroy
  has_many :metadata, :through => :metataggings#, :dependent => :destroy
  has_many :taggings, :source => :cloud_file_tagging#, :dependent => :destroy
  has_many :cloud_file_taggings#, :dependent => :destroy
  has_many :tags, :through => :cloud_file_taggings

  accepts_nested_attributes_for :metataggings

  validates_uniqueness_of :md5, :scope => :bucket_id
  validates_presence_of :bucket_id

<<<<<<< HEAD
=======
  attr_accessor :relative_path, :path_to_file

  before_save :parse_relative_path
>>>>>>> Refactored code to use Resque uploader for cloudfile and a Tagger
  after_destroy :delete_remote

  # default_scope { includes(:bucket => :region) }
  default_scope { includes(:bucket => :region).where(:adult => false) }

  def visit
    system "open #{self.url}"
  end

  class << self

    def online?(uri)
      url = URI.parse(uri)
      req = Net::HTTP.new(url.host, url.port)
      req.request_head(url.path).code == "200"
    end


    def ingest(path_to_file, bucket, options={})
      cloud_file = CloudFile.upload path_to_file, bucket, options
      tagger = Tagger::Factory.generate(cloud_file)
      tagger.inspect!
      cloud_file
    end


    def ingest!(path_to_file, bucket, options={})
      CloudFile.ingest path_to_file, bucket, options.merge(:prune => true)
    end

    def upload!(path_to_file, bucket, options={})
      CloudFile.upload path_to_file, bucket, options.merge(:prune => true)
    end

    def upload(path_to_file, bucket, options={})
      if options[:async].present?
        Resque.enqueue(CloudFileUploader, path_to_file, bucket, options)
      else
        CloudFileUploader.perform(path_to_file, bucket, options)
      end
    end

    def sanitize(name)
      name = name.tr("\\", "/") # work-around for IE
      name = File.basename(name)
      name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/, "_")
      name = "_#{name}" if name =~ /\A\.+\z/
      name = "unnamed" if name.size == 0
      return name.mb_chars.to_s
    end
  end


  def smart_name
    self.name || self.asset
  end

  def url
    raise "Region Not Defined for bucket: #{self.bucket.name}" if self.bucket.region_id.blank?
    @url ||= "http://#{self.bucket.name}.#{self.bucket.region.endpoint}/#{md5.scan(/.{2}|.+/).join("/")}/#{self.asset}"
  end

  def filename
    self.asset
  end

  def path
    @path ||= "#{self.md5.scan(/.{2}|.+/).join("/")}/#{self.filename}"
  end

  def delete_remote
    self.user.s3_client.delete_object(
      # required
      :bucket => self.bucket.name,
      # required
      :key => self.path
    )
  end

  def tag_list=(tag_array)
    tag_array.each do |value|
      tag = Tag.find_or_create_by! :value => value, :user_id => self.user.id
      self.cloud_file_taggings.find_or_initialize_by! :tag_id => tag.id
    end

    binding.pry
  end

  def metadata_list=(info)
    binding.pry    
  end


  # def progress
  #   file = File.open(filepath, 'r', encoding: 'BINARY')
  #   file_to_upload = "#{s3_dir}/#{filename}"
  #   upload_progress = 0

  #   opts = {
  #     content_type: mime_type,
  #     cache_control: 'max-age=31536000',
  #     estimated_content_length: file.size,
  #   }

  #   part_size = self.compute_part_size(opts)

  #   parts_number = (file.size.to_f / part_size).ceil.to_i
  #   obj          = s3.objects[file_to_upload]

  #   begin
  #       obj.multipart_upload(opts) do |upload|
  #         until file.eof? do
  #           break if (abort_upload = upload.aborted?)

  #           upload.add_part(file.read(part_size))
  #           upload_progress += 1.0/parts_number

  #           # Yields the Float progress and the String filepath from the
  #           # current file that's being uploaded
  #           yield(upload_progress, upload) if block_given?
  #         end
  #       end
  #   end
  # end
  ############################################################################
  private
  ############################################################################


end
