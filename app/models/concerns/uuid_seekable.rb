module UuidSeekable
  extend ActiveSupport::Concern

  module ClassMethods
    # defines class level function
    def seek(id)
      id_as_string = id.to_s
      # if an intger
      if id_as_string.to_s.is_i?
        find_by(id: id)
      elsif id_as_string.to_s.valid_uuid?
        where("#{uuid_key_column} = ?",  id_as_string).take
      else
        where("#{uuid_key_column}::text like '#{id_as_string}%'").take
      end
    end

    def seek!(id)
      obj = self.seek(id)
      raise ActiveRecord::RecordNotFound if obj.blank?
    end

    def uuid_key(key)
      @uuid_key = key
    end

    def uuid_key_column
      @uuid_key_column = @uuid_key || :uuid
    end
  end
end
