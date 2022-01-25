# frozen_string_literal: true

# == Schema Information
#
# Table name: cloud_files
#
#  id             :integer          not null, primary key
#  name           :string
#  asset          :string
#  md5            :string
#  content_type   :string
#  filesize       :bigint           default(0)
#  description    :text
#  rating         :float
#  nsfw           :boolean          default(FALSE)
#  peepy          :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  folder_id      :integer
#  info_url       :string
#  bucket_id      :integer
#  duration       :integer          default(0)
#  settings       :integer          default(0), not null
#  ext_id         :string
#  data_source_id :integer
#  release_id     :integer
#  year           :integer
#  release_pos    :integer
#  user_id        :integer
#  num_plays      :integer          default(0), not null
#
class CloudFile < ApplicationRecord
  include Reactable
  include AASM

  belongs_to :folder, counter_cache: true
  belongs_to :bucket#, inverse_of: :cloud_file
  belongs_to :release, counter_cache: true
  belongs_to :user
  has_many :artist_cloud_files, dependent: :destroy
  has_many :artists, through: :artist_cloud_files
  has_many :metataggings, dependent: :destroy, autosave: true
  has_many :metadata, through: :metataggings, dependent: :destroy, autosave: true

  scope(:alpha, -> { order('name') })
  scope(:peepy, -> { where(peepy: true) })

  accepts_nested_attributes_for :metataggings

  validates_uniqueness_of :md5, scope: :folder_id
  validates_presence_of :bucket_id
  validates_presence_of :md5

  aasm :state do # add locking
    state :empty, initial: true
    state :reserved
    state :transfered, before_enter: :assign_xfer_attributes
    state :completed, before_enter: :complete_metadata_assigment

    event :reserve do
      transitions from: :empty, to: :reserved
    end

    event :transfer do
      transitions from: :reserved, to: :transfered
    end

    event :complete do
      transitions from: :transfered, to: :completed
    end
  end

  def assign_xfer_attributes(params = {})
    assign_attributes(params)
  end

  def complete_metadata_assigment(params = {})
    update! params
  end

  class << self
    def seek(value)
      CloudFile.where('id = ? OR md5 = ?', value.to_i, value.to_s).take
    end

    def online?(uri)
      url = URI.parse(uri)
      req = Net::HTTP.new(url.host, url.port)
      req.request_head(url.path).code == '200'
    end

    def sanitize(name)
      name = name.tr('\\', '/') # work-around for IE
      name = File.basename(name)
      name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/, '_')
      name = "_#{name}" if name =~ /\A\.+\z/
      name = 'unnamed' if name.size.zero?
      name.mb_chars.to_s
    end
  end

  def online?
    CloudFile.online?(url)
  end

  def smart_name
    name || asset
  end

  def url
    raise "Region Not Defined for bucket: #{bucket.name}" if bucket.region_id.blank?

    @url ||= "http://#{self.bucket.name}.#{self.bucket.region.endpoint}/#{media_type}/#{md5.scan(/.{2}|.+/).join("/")}/#{self.asset}"
  end

  def filename
    asset
  end

  def path
    @path ||= "#{self.md5.scan(/.{2}|.+/).join("/")}/#{self.filename}"
  end

  def delete_remote
    user.s3_client.delete_object(
      # required
      bucket: bucket.name,
      # required
      key: path
    )
  end

  def media_type
    content_type.to_s.split('/')&.first
  end

  def display_type
    type = content_type.to_s.split('/')&.first
    type = "peepshow (#{type})" if peepy?
    type
  end

  def metadata_list=(list)
    list.each do |key, value|
      type = MetadataType.find_or_create_by!(value: key)
      metadata << Metadatum.find_or_create_by!(value: value, user_id: user_id, metadata_type_id: type.id).tap do |obj|
        obj.peepy = peepy
        obj.nsfw  = nsfw
      end
    end
  end


  ############################################################################
  private
  ############################################################################

  def prune_release
    # release.destroy if self.release.cloud_files.blank?
  end
end
