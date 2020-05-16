# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  descr      :string           not null
#  name       :string           not null
#  endpoint   :string           not null
#  location   :string
#  created_at :datetime
#  updated_at :datetime
#
class Region < ApplicationRecord
end
