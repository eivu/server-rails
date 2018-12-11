# libchromaprint-dev                                       - audio fingerprinting library - development files                   
# libchromaprint-tools                                     - audio fingerprinting library - tools                               
# libchromaprint1                                          - audio fingerprint library  

class Fingerprinter

  def initialize(path_to_file=nil)
    path_to_file ||= "/home/bobert/files/Kendrick_Lamar_&_The_Weeknd_&_SZA/Black_Panther_The_Album_Music_From_And_Inspired_By_[Explicit]/B078SGLXJR_(disc_1)_03_-_X_[Explicit].mp3"
    @path_to_file = path_to_file
    perform
  end

  def perform
    # call fingerprint calculator
    @output = `fpcalc "#{@path_to_file}"`
    # output is in the format of:
    # DURATION=267
    # FINGERPRINT=AQADtHKTZFJG7LSwHxeJuGmhj4i6Bj
    @output.split("\n").each do |line|
      key, value = line.strip.split("=")
      instance_variable_set("@#{key.downcase}", value)
    end
  end

  def submit
    @response = RestClient.get "https://api.acoustid.org/v2/lookup?client=o4Wf01oR4K&duration=#{@duration}&fingerprint=#{@fingerprint}"
  end
end

