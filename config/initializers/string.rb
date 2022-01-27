class String
  def is_integer?
    /\A[-+]?\d+\z/ === self
  end

  def is_i?
    self.is_integer?
  end

  def valid_uuid?
    (/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/ =~ self).present?
  end
end