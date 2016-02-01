class Region < ActiveRecord::Base
  has_many :buckets, :inverse_of => :region
end
