module UuidSeekable
  extend ActiveSupport::Concern

  module ClassMethods
    # defines class level function
    def seek(id)
      id_as_string = id.to_s
      # if an intger
      if id_as_string.to_s.is_i?
        self.find_by(id: id)
      else #if a string
        if id_as_string.to_s.valid_uuid?
          self.find_by(md5: id_as_string)
        else
          self.where("md5::text like '#{id_as_string}%'").take
        end
      end
    end

    def seek!(id)
      obj = self.seek(id)
      raise ActiveRecord::RecordNotFound if obj.blank?
    end
  end
end
