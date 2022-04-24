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
        where("#{uuid_key} = ?",  id_as_string).take
      else
        where("#{uuid_key}::text like '#{id_as_string}%'").take
      end
    end

    def seek!(id)
      obj = self.seek(id)
      raise ActiveRecord::RecordNotFound if obj.blank?
    end

    # method to be used in the model
    def has_uuid(key=:uuid)
      class_variable_set(:@@uuid_key, key)
    end

    # column name, either defined by model via @@uuid_key or is the default column uuid
    def uuid_key
      class_variable_get(:@@uuid_key)
    end
  end

  def uuid_key
    self.class.uuid_key
  end

  def set_uuid
    return unless send(uuid_key).blank?

    send("#{uuid_key}=", SecureRandom.uuid)
  end
end
