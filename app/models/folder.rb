# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime
#  updated_at        :datetime
#  ancestry          :string
#  bucket_id         :integer
#  peepy             :boolean          default(FALSE), not null
#  nsfw              :boolean          default(FALSE), not null
#  cloud_files_count :integer          default(0), not null
#  subfolders_count  :integer          default(0), not null
#
# Description: Folders are only metadata to preserve the same tree layout as found on the user's drive
class Folder < ApplicationRecord
  include Reactable
  include UuidSeekable
  # Hotwire Implementation
  broadcasts_to ->(_) { 'folders' }
  has_ancestry
  has_uuid
  after_initialize :set_uuid

  belongs_to :bucket
  has_many :cloud_files, -> { order('release_pos') }

  validates :bucket_id, presence: true
  validates :name, uniqueness: { scope: :ancestry }

  scope(:alpha, -> { order('name') })
  scope(:clean, -> { where(peepy: false) })
  scope(:peepy, -> { where(peepy: true) })

  scope(:has_files, -> { where('cloud_files_count > 0') })
  scope(:has_subfolders, -> { where('subfolders_count > 0') })
  scope(:has_content, -> { where('subfolders_count > 0 OR cloud_files_count > 0') })
  # default_scope { where(:peepy => false) }

  class << self
    def find_or_create_from_path(fullpath:, bucket_id:, peepy: false, nsfw: false)
      # save file in "root" of folder if ignore is blank
      # return nil if ignore.blank?
      return if fullpath.blank?

      parent = nil
      folder = nil
      fullpath.split('/').each do |folder_name|
        folder = Folder.find_or_create_by!(name: folder_name, ancestry: parent.try(:path_ids).try(:join, '/'), bucket_id: bucket_id)
        folder.update(peepy: peepy, nsfw: nsfw)
        parent = folder
      end

      folder
    end
  end

  def toggle_expansion
    update! expanded: !expanded
  end
end
