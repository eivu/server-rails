module ConfigureAndSavable

  extend ActiveSupport::Concern

  module ClassMethods
    def configure_and_save!(attr)
      attr.symbolize_keys!
      klass = self

# :name => 3, :ext_id => 1, :data_source_id => 2
      keys = attr.keys
      #####
      # testing if both arrays/sets contain same values

      # do we have all 3 values
      # if keys.to_set == Set.new([:name, :ext_id, :data_source_id])

# a= {:name=>"Adele", :ext_id=>"cc2c9c3c-b7bc-4b8b-84d8-4fbd8779e493", :data_source_id=>1}
      hash_has_all_keys = [:name, :ext_id, :data_source_id].all? {|s| attr.key? s}

      # does the artist already exist within the system with a different spelling ie: Jay-Z vs JAY Z
      obj_via_id        = klass.find_by_ext_id(attr[:ext_id])
      return obj_via_id if obj_via_id.present?

      obj_via_id_more   = klass.find_or_initialize_by :name => attr[:name], :ext_id => attr[:ext_id], :data_source_id => attr[:data_source_id]
      # short circuit: return the object if it a
      return obj_via_id_more if obj_via_id_more.persisted?

      obj_via_name = klass.find_or_initialize_by :name => attr[:name]

      # hash has all desired keys, we want to create new object OR update existing
      if hash_has_all_keys
        # if obj_via_name exists, then we will update and return the existing object with attr
        # else no data exists so we will save and return obj_via_id_more
        if obj_via_name.persisted?
          obj_via_name.update_attributes!(attr)
          final_object =  obj_via_name
        else
          obj_via_id_more.save!
          final_object = obj_via_id_more
        end
      else
        # rails will only touch the db if needed, so need to determine if the object is new or old
        obj_via_name.save!
        final_object = obj_via_name
      end
      final_object
    end
  end
end