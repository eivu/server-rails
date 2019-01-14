module Tagger


  class Test
    def self.run
      # cloud_file = Bucket.last.cloud_files.last
      # cloud_file.path_to_file = "/Users/jinx/Dropbox/eivu/sample/Sound Effects/Cow-SoundBible.com-868293659.mp3"
      # Tagger::Factory.generate(cloud_file).identify!
# path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/Compilations/Essential\ Mix/11.08.2008\ \(256kbit\).m4a"
 # path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/White\ Label/Alicia/01\ Alicia.mp3"

      Tagger::Factory.generate("/Users/jinx/Dropbox/eivu/sample/Mala/Alicia/01\ Alicia.mp3").identify!
    end
  end

  class Factory
    def self.generate(input)
      if input.is_a? String
        path_to_file = input
      elsif input.is_a? CloudFile
        cloud_file = input
        path_to_file = input.path_to_file
      end

      extension = File.extname(path_to_file)
      file      = File.open(input)
      if extension.present?
        mime      = MimeMagic.by_extension(".m4a")
      else
        mime      = MimeMagic.by_magic(file)
      end

      klass     = Kernel.const_get("Tagger::#{mime.mediatype.titlecase}")
      klass.new(input, mime, file)
    end
  end

  class Base
    def initialize(input, mime, file)
      if input.is_a? String
        @path_to_file = input
      elsif input.is_a? CloudFile
        @cloud_file   = input
        @path_to_file = input.path_to_file
      end

      @mime       = mime
      @file       = file
      @attributes = {}
    end

    def self.set_flags_via_path(path_to_file)
      if path_to_file.present? && (path_to_file.include?("/pronz") || path_to_file.include?("/peepshow"))
        {
          :adult => true,
          :nsfw => true
        }
      end
    end


    def save_data
      @release = Release.find_or_create_by!(@release_attrs)
      @release_artists.each do |raw_artist|
        artist = Artist.find_or_create_by! :name => raw_artist.name, :ext_id => raw_artist.id, :data_source_id => @release.data_source_id
        ArtistRelease.find_or_create_by! :artist_id => artist.id, :release_id => release.id, :relationship_id => ( raw_artist.primary ? 1 : 2)
      end
    end
  end


  class Audio < Base
    def identify!
      @id3_attr       = Hashie::Mash.new
      @fp_attr = {}
      ################
      #
      # Get Info via ID3
      id3_info        = ID3Tag.read(@file)
      
      @id3_attr[:_source]   = id3_info.get_frame(:PRIV).try(:owner_identifier) #"www.amazon.com"
      @id3_attr[:artists]   = [{:name => id3_info.artist, :primary => true}]
      @id3_attr[:title]     = id3_info.title
      @id3_attr[:release]   = id3_info.album
      @id3_attr[:year]      = id3_info.year
      @id3_attr[:track_num] = id3_info.track_nr
      @id3_attr[:genre]     = id3_info.genre
      @id3_attr[:comments]  = id3_info.comments.try(:strip)
      @id3_attr[:artwork]   = id3_info.get_frame(:APIC).try(:content)


      ################
      #
      # Get Info via AcouticFingerprint Service
      fingerprint     = Fingerprinter.new(@path_to_file)
      fingerprint.submit if fingerprint.cleansed_fingerprint.present?

      @flags_via_path = Tagger::Audio.set_flags_via_path(@path_to_file)

      if @id3_attr[:_source].present?
        track_id     = nil
        track_name   = @id3_attr[:title]
        release_id   = nil
        release_name = @id3_attr[:release]
      else
        track_id     = fingerprint.track.try(:id)
        track_name   = fingerprint.track.try(:title) || @id3_attr.title
        release_id   = fingerprint.release.try(:id)
        release_name = fingerprint.release.try(:title) || @id3_attr.release
      end


      @release_artists = fingerprint.try(:release).try(:artists) || @id3_attr[:artists]
      @track_artists   = fingerprint.try(:track).try(:artists) || @id3_attr[:artists]

      @release_attrs = {
        :name => release_name,
        :ext_id => release_id,
        :data_source_id => 1
      }.merge(flags_via_path).compact

      @cloud_file_attrs = {
        :ext_id => 
        :data_source_id => 1,
        :position => @id3_attr[:track_num],
        :year => @id3_attr[:year]
      }.merge(flags_via_path).compact

      @metadata = Hashie::Mash.new({
        :genre => @id3_attr[:genre],
        :comments => @id3_attr[:comments],
        :acoustid_fingerprint => fingerprint.try(:cleansed_fingerprint)
      }).compact


    end
  end

  class Video < Base
    def determine_rating(path_to_file)
      if Pathname.new(path_to_file).basename.to_s.starts_with?("_")
        5
      elsif Pathname.new(path_to_file).basename.to_s.starts_with?("`")
        4.5
      end
    end


  end


end
