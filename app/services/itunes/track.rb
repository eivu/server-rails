class Itunes::Track

  def initialize(raw_track_info)
    @track_info = raw_track_info.simplify
    @track_info[:total_time] = @track_info[:total_time].to_i/1000
  end

  def path_to_file
    @track_info[:location].gsub("file:///", "/")
  end

  def method_missing(method, *args)
    method = method.to_sym
    if @track_info[method].present?
      return @track_info[method]
    else
      super
    end
  end

end
