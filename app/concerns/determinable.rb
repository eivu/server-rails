module Determinable

  extend ActiveSupport::Concern

  module ClassMethods
    def determine(obj)
      klass = self
      if obj.kind_of?(klass)
        obj
      #is obj a number in quotes
      elsif obj.to_i.to_s == obj.to_s
        klass.find(obj)  
      elsif klass.kind_of?(String)
        klass.find_by_name(obj)
      else
        raise "#{klass.name} not found with id (#{id})"
      end
    end
  end
end