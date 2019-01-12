# libchromaprint-dev                                       - audio fingerprinting library - development files                   
# libchromaprint-tools                                     - audio fingerprinting library - tools                               
# libchromaprint1                                          - audio fingerprint library  

class Fingerprinter

  attr_reader :path_to_file, :output, :fp_url, :response, :raw_response, :cleansed_fingerprint, :duration, :top_result, :top_release

  def initialize(path_to_file=nil)
    path_to_file ||= "/home/bobert/files/Kendrick_Lamar_&_The_Weeknd_&_SZA/Black_Panther_The_Album_Music_From_And_Inspired_By_[Explicit]/B078SGLXJR_(disc_1)_03_-_X_[Explicit].mp3"
    @path_to_file = path_to_file
    generate
  end

  def generate
    # call fingerprint calculator
    @output = `fpcalc "#{@path_to_file}"`
    # output is in the format of:
    # DURATION=267
    # FINGERPRINT=AQADtHKTZFJG7LSwHxeJuGmhj4i6Bj
    @output.split("\n").each do |line|
      key, value = line.strip.split("=")
      instance_variable_set("@#{key.downcase}", value)
    end
    @cleansed_fingerprint = @fingerprint.try(:gsub, /[^0-9a-z ]/i, '')
  end

  def submit
    @fp_url = "https://api.acoustid.org/v2/lookup?client=o4Wf01oR4K&duration=#{@duration}&fingerprint=#{@fingerprint}&meta=recordings+releasegroups+compress"
    @raw_response = RestClient.get @fp_url
    @response = Oj.load @raw_response
    parse_results
  end

  def parse_results
    # make sure both results and the recordings block exist
    @acoustid = @response["results"].try(:first).try(:[], "id")
    if @response["results"].present? && @response["results"][0]["recordings"].present?
      @top_result  = @response["results"][0]["recordings"][0].dup
      @top_release = @top_result.delete("releasegroups").try(:first)
    else
      @top_result  = {}
      @top_release = {}
    end
  end

end

