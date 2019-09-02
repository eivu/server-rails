class Fingerprinter::Results

  attr_reader :path_to_file, :output, :fp_url, :response, :raw_response, :cleansed_fingerprint, :duration, :track, :release


  def initialize(results)
  end


  ######### Tagger

  def best_matching_release
    if @mp3_attr[:release].present? && @fingerprint.response.present?
      # use release if it was found via fuzzy, otherwise use other_release_sources
      release = @fingerprint.release if @fingerprint.found_via_fuzzy?
      release ||= other_release_sources
    elsif @mp3_attr[:release].present?
      release = { :title => @mp3_attr[:release] }
    elsif @fingerprint.release.present?
      release = @fingerprint.release
    else
      release = {}
    end
    release
  end




  ######### Fingerprinter

  # converts artist hash into a format that can be used with Tagger and the larger app
  def self.parse_artists(array)
    # & means primary, anything else means supporting
    join_chars = ["&"] + array.collect {|x| x[:joinphrase]}.compact.collect(&:strip)
  
    array.collect.with_index do |hash, index|
      hash.symbolize_keys!
      if array.size == 1 || join_chars[index] == "&"
        hash = hash.slice(:id, :name).merge(:primary => true)
      else
        hash = hash.slice(:id, :name).merge(:primary => false)
      end
      hash.rename_key(:id, :ext_id)
    end
  end


  def parse
    # make sure both results and the recordings block exist
    # dup is being used throughout so the original object can be referenced without encountering any side effects

    if first_result_recordings.present? && best_recording.present?
      @acoustid   = best_recording.try(:id)
      result    = best_recording.dup
      deleted_rg= result.delete(:releasegroups)
      album     = self.matched_release || deleted_rg.try(:first) || {}
      temp_data = result.dup.recursive_symbolize_keys!

      @track    = Hashie::Mash.new(temp_data.slice(:id, :title, :duration).rename_key(:id, :ext_id))
      @track.artists = Fingerprinter.parse_artists(result.dup.artists)
      @release  = Hashie::Mash.new(album.dup.slice('id', 'title', 'type')).rename_key(:id, :ext_id)
      # if album artists are blank use the result artists
      @release.artists = Fingerprinter.parse_artists(album.artists || result.artists)
    else
      @track  = {}
      @release = {}
    end
    :ok
  end



  def found_via_fuzzy?
    @found_via_fuzzy.present?
  end






  def matched_release
    if self.found_via_fuzzy?
      filtered_release
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
      # best_recording = first_result_recordings.detect {|entry| entry.releasegroups.include?(filtered_release) }
      
      best_recording = first_result_recordings.detect {|entry| entry.releasegroups.try(:include?, filtered_release) }

      # if we found something, then let's flag we found it via fuzzy matching
      @found_via_fuzzy  = true if best_recording.present?
    else
      best_recording = first_result_recordings.detect{|x| (x.try(:duration).to_i - @duration).abs <= 5 }
    end

    # return best recording or empty Hashie
    best_recording || Hashie::Mash.new
  end




  # finds fuzzy matching releases across all recordings 
  def filtered_release
    return nil if first_result_recordings.blank? || @release_name.blank?
    # caching the result

    @filtered_release ||= 
      (
        filtered = first_result_recordings.select{|x| (x.try(:duration).to_i - @duration).abs <= 15 } || Hashie::Mash.new
        release = filter_matching_releases_from_array(filtered)
      )
  end


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


  def filter_matching_releases_from_array(obj)
    return nil if obj.blank? || @release_name.blank?
    titles = obj.collect {|x| x.releasegroups.collect(&:title)}.flatten

    matcher = FuzzyMatch.new(titles)
    match = matcher.find(@release_name)

    return nil if match.blank?

    obj.each do |entry|
      value = entry.releasegroups.detect {|hash| hash.title == match }
      return value if value.present?
    end

    nil
  end

end