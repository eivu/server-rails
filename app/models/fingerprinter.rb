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

  def initialize(track_name, release_name, path_to_file=nil)
    @track_name   = track_name
    @release_name = release_name
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

  def parse_results
    # make sure both results and the recordings block exist
    # dup is being used throughout so the original object can be referenced without encountering any side effects
    if first_result_recordings.present? && best_recording.present?
      @acoustid   = best_recording.try(:id)
      result    = best_recording.dup
      deleted_rg= result.delete(:releasegroups)

      album     = @best_release || deleted_rg.try(:first) || Hashie::Mash.new
      @track    = result.dup.slice(:id, :title, :duration).rename_key(:id, :ext_id)
      @track.artists = parse_artists(result.dup.artists)
      @release  = album.dup.slice(:id, :title, :type).rename_key(:id, :ext_id)
      # if album artists are blank use the result artists
      @release.artists = parse_artists(album.artists || result.artists)

      binding.pry
    else
      @track  = {}
      @release = {}
    end
    :ok
  end


  # # release[group] closest to input string
  # def matching_release(string)
  #   return nil if best_recording.blank? || string.blank?
  #   titles = best_recording.releasegroups.collect(&:title)

  #   matcher = FuzzyMatch.new(titles)
  #   match = matcher.find(string)

  #   hash = best_recording.releasegroups.detect {|hash| hash.title == match }

  #   if hash.present?
  #     hash.rename_key(:id, :ext_id)
  #   else
  #     nil
  #   end
  # end


  def return_matching_release_hashes(obj)
    return nil if obj.blank? || @release_name.blank?
    titles = obj.releasegroups.collect(&:title)

    matcher = FuzzyMatch.new(titles)
    match = matcher.find(@release_name)

    hash = obj.releasegroups.detect {|hash| hash.title == match }

    if hash.present?
      hash#.rename_key(:id, :ext_id)
      # hash
    else
      nil
    end
  end


  ##################
  private
  ##################

  def first_result_recordings
    @response.try(:results).try(:first).try(:recordings).dup
  end

  # finds the best recording by fuzzy matching release names and comparing track durations
  def best_recording
    # short circuit with empty Hashie::Mash if no data to work with
    return Hashie::Mash.new if first_result_recordings.blank?

    # retrieve release with closest release/album title or with a similiar duration
    if filtered_release.present?
      best_recording = first_result_recordings.detect {|entry| entry.releasegroups.include?(filtered_release) }
      # if we found something, then the matching entry is indeed the best release
      @best_release  = filtered_release if best_recording.present?
    else
      best_recording = first_result_recordings.detect{|x| (x.try(:duration).to_i - @duration).abs <= 5 }
    end

    # return best recording or empty Hashie
    best_recording || Hashie::Mash.new
  end


  # converts artist hash into a format that can be used with Tagger and the larger app
  def parse_artists(array)
    # & means primary, anything else means supporting
    join_chars = ["&"] + array.collect {|x| x[:joinphrase]}.compact.collect(&:strip)
  
    array.collect.with_index do |hash, index|
      if join_chars[index] == "&"
        hash = hash.slice(:id, :name).merge(:primary => true)
      else
        hash = hash.slice(:id, :name).merge(:primary => false)
      end
      hash.rename_key(:id, :ext_id)
    end
  end


  # finds fuzzy matching releases across all recordings 
  def filtered_release
    return nil if first_result_recordings.blank? || @release_name.blank?
    # caching the result
    @filtered_release ||= 
      (
        filtered = first_result_recordings.select{|x| (x.try(:duration).to_i - @duration).abs <= 5 } || Hashie::Mash.new
        filtered = filtered.collect{|x| return_matching_release_hashes(x) }.compact.uniq
        release  = filtered.first
        release
      )
  end


end

