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

class Fingerprinter::Core

  attr_reader :path_to_file, :output, :fp_url, :response, :raw_response, :cleansed_fingerprint

  def initialize(track_name, release_name, path_to_file=nil)
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
    # make duration an integer
    if @duration.present?
      @duration = @duration.to_i
    end
    @cleansed_fingerprint = @fingerprint.try(:gsub, /[^0-9a-z ]/i, '')
  end

  def submit
    @fp_url = "https://api.acoustid.org/v2/lookup?client=o4Wf01oR4K&duration=#{@duration}&fingerprint=#{@fingerprint}&meta=recordings+releasegroups+compress"
    @raw_response = RestClient.get @fp_url
    @response = Hashie::Mash.new(Oj.load(@raw_response))
    parse_results
  end


end

