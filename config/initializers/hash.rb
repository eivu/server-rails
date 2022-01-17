class Hash
  def recursive_symbolize_keys!
    symbolize_keys!
    # symbolize each hash in .values
    values.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    # symbolize each hash inside an array in .values
    values.select{|v| v.is_a?(Array) }.flatten.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    self
  end


  def rename_key(old_name, new_name)
    self[new_name] = self.delete(old_name)
    self
  end

  def clean_foreign_keys
    self.inject({}) do |hash, (key, value)|
      if key.to_s.ends_with?("_id")
        hash[key] = value.gsub(/[^0-9 ]/i, '').to_i
      else
        hash[key] = value
      end
      hash
    end
  end

  # turns all keys to symbols, that are lowerased and have spaces replaced with _
  def simplify
    Hash[self.to_hash.map { |k, v| [k.to_s.strip.downcase.gsub(" ","_").to_sym, v.to_s] }].compact
  end

  def flatten_nested
    flat_map{|k, v| [k, *v.flatten_nested]}
  end

  def remove_empty(opts={})
    inject({}) do |new_hash, (k,v)|
      if !v.blank?
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact(opts) : v
      end
      new_hash
    end
  end
  
  def remove_empty_r(opts={})
    inject({}) do |new_hash, (k,v)|
      if !v.nil?
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact_r(opts) : v
      end
      new_hash
    end
  end

  def remove_blank_r_v2(opts={})
    inject({}) do |new_hash, (k,v)|
      if !v.blank?
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact_blank_r(opts) : v
      end
      new_hash
    end
  end

  def compact_blank_with_boolean_r(opts={})
    inject({}) do |new_hash, (k,v)|
      if !v.blank? || v.kind_of?(TrueClass) || v.kind_of?(FalseClass)
        new_hash[k] = opts[:recurse] && v.class == Hash ? v.compact_blank_r(opts) : v
      end
      new_hash
    end
  end
end