module Reactable

  extend ActiveSupport::Concern

  def dom_uuid
    "#{self.class.name.camelize(:lower)}#{id}"
  end

  def klass
    self.class.name.camelize(:lower)
  end

  def entry_type
    if self.class.name == "CloudFile"
      "file"
    else
      "grouping"
    end 
  end

end