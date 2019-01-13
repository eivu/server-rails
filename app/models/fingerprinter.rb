# Should be used for testing in a spec
#   [{"joinphrase"=>" & ", "id"=>"f82bcf78-5b69-4622-a5ef-73800768d9ac", "name"=>"JAY Z"}, {"id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "name"=>"Kanye West"}],
#   [{"joinphrase"=>" & ", "id"=>"0d7b68b7-6039-4883-8214-9eeb13f8c283", "name"=>"Zacari"}, {"id"=>"d8b9e0dd-2d22-49f3-9b19-6440527f1c8b", "name"=>"Babes Wodumo"}],
#   [{"id"=>"381086ea-f511-4aba-bdf9-71c753dc5077", "name"=>"Kendrick Lamar"}],
#   [{"joinphrase"=>" & ", "id"=>"381086ea-f511-4aba-bdf9-71c753dc5077", "name"=>"Kendrick Lamar"}, {"id"=>"272989c8-5535-492d-a25c-9f58803e027f", "name"=>"SZA"}],
#   [{"joinphrase"=>" & ", "id"=>"f82bcf78-5b69-4622-a5ef-73800768d9ac", "name"=>"JAY Z"},
#    {"joinphrase"=>" feat. ", "id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "name"=>"Kanye West"},
#    {"id"=>"859d0860-d480-4efd-970c-c05d5f1776b8", "name"=>"Beyoncé"}]
# ]


# libchromaprint-dev                                       - audio fingerprinting library - development files                   
# libchromaprint-tools                                     - audio fingerprinting library - tools                               
# libchromaprint1                                          - audio fingerprint library  

class Fingerprinter

  attr_reader :path_to_file, :output, :fp_url, :response, :raw_response, :cleansed_fingerprint, :duration, :track, :release

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
    @response.recursive_symbolize_keys!
    parse_results
  end

  def parse_results
    # make sure both results and the recordings block exist
    @acoustid   = @response[:results].try(:first).try(:[], :id)
    if @response[:results].present? && @response[:results][0][:recordings].present?
      result    = @response[:results][0][:recordings][0].dup
      album    = result.delete(:releasegroups).try(:first)
      @track    = Hashie::Mash.new(result.slice(:id, :title, :duration))
      @track.artists = parse_artists(result[:artists])
      @release  = Hashie::Mash.new(album.slice(:id, :title, :type))
      @release.artists=parse_artists(album[:artists])
    else
      @track  = {}
      @release = {}
    end
    :ok
  end




  def parse_artists(array)
    attributes = { :primary => [], :secondary => [] }
    # & means primary, anything else means supporting
    join_chars = ["&"] + array.collect {|x| x[:joinphrase]}.compact.collect(&:strip)
    array.each_with_index do |hash, index|
      if join_chars[index] == "&"
        attributes[:primary] << hash.slice(:id, :name)
      else
        attributes[:secondary] << hash.slice(:id, :name)
      end
    end
    attributes
  end

end

