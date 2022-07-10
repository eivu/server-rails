# frozen_string_literal: true

# == Schema Information
#
# Table name: metataggings
#
#  id            :integer          not null, primary key
#  cloud_file_id :integer
#  metadatum_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Metatagging < ApplicationRecord
  belongs_to :cloud_file
  belongs_to :metadatum, counter_cache: :cloud_files_count

  def value=(string)
    user = self.cloud_file.user
    raise 'Assignment impossible if cloud_file undefined' if user.blank?

    self.metadatum = Metadatum.find_or_create_by!(value: string)
  end
end
