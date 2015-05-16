module RestClient

  def self.rescued_get(url_string)
    request = RestClient::Resource.new url_string
    begin
      request.get
    rescue => e
      e.response
    end
  end

end