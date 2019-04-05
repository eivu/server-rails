module Tagger


  class Test
    def self.id
      # cloud_file = Bucket.last.cloud_files.last
      # cloud_file.path_to_file = "/Users/jinx/Dropbox/eivu/sample/Sound Effects/Cow-SoundBible.com-868293659.mp3"
      # Tagger::Factory.generate(cloud_file).identify!

      # path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/Compilations/Essential\ Mix/11.08.2008\ \(256kbit\).m4a"
      # path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/White\ Label/Alicia/01\ Alicia.mp3"

      # cf = CloudFile.find(1978)
      # cf.path_to_file = "/Users/jinx/Desktop/sample/Justin\ Timberlake/Suit\ \&\ Tie\ \(Feat\ JAY\ Z\)\ -\ Single/01\ Suit\ \&\ Tie.mp3"
      # Tagger::Factory.generate("/Users/jinx/Dropbox/eivu/sample/Mala/Alicia/01\ Alicia.mp3").identify!
      # obj = cf
      # obj = "/Users/jinx/Desktop/sample/Justin\ Timberlake/Greatest\ Hits/05\ Rock\ Your\ Body.mp3"
      # obj = "/Users/jinx/Desktop/sample/Justin\ Timberlake/Greatest\ Hits/13\ \(Oh\ No\)\ What\ You\ Got.mp3"
      # obj = "/Users/jinx/Desktop/sample/Justin\ Timberlake/Greatest\ Hits/08\ Summer\ Love\ \(Set\ The\ Mood\).mp3"
      # obj = "/Users/jinx/Desktop/sample/Justin\ Timberlake/Greatest\ Hits/02\ What\ Goes\ Around,\ Comes\ Around.mp3"
      obj= "/Users/jinx/Desktop/foo/Justin\ Timberlake/Justified/06\ Rock\ Your\ Body.mp3"
      t = Tagger::Factory.generate(obj)
      t.identify
    end


    def self.run
      # cloud_file = Bucket.last.cloud_files.last
      # cloud_file.path_to_file = "/Users/jinx/Dropbox/eivu/sample/Sound Effects/Cow-SoundBible.com-868293659.mp3"
      # Tagger::Factory.generate(cloud_file).identify!

      # path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/Compilations/Essential\ Mix/11.08.2008\ \(256kbit\).m4a"
      # path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/White\ Label/Alicia/01\ Alicia.mp3"
      
      cf = CloudFile.find(1978)
      cf.path_to_file = "/Users/jinx/Desktop/sample/Justin\ Timberlake/Suit\ \&\ Tie\ \(Feat\ JAY\ Z\)\ -\ Single/01\ Suit\ \&\ Tie.mp3"
      # Tagger::Factory.generate("/Users/jinx/Dropbox/eivu/sample/Mala/Alicia/01\ Alicia.mp3").identify!
      Tagger::Factory.generate(cf).identify_and_update!
    end


    def self.response

      title = "Suit & Tie (Feat JAY Z) - Single"
      response = {"status"=>"ok", "results"=>[{"recordings"=>[{"artists"=>[{"joinphrase"=>" feat. ", "id"=>"596ffa74-3d08-44ef-b113-765d43d12738", "name"=>"Justin Timberlake"}, {"id"=>"f82bcf78-5b69-4622-a5ef-73800768d9ac", "name"=>"Jay-Z"}], "duration"=>326, "releasegroups"=>[{"artists"=>[{"id"=>"596ffa74-3d08-44ef-b113-765d43d12738", "name"=>"Justin Timberlake"}], "type"=>"Album", "id"=>"deae6fc2-a675-4f35-9565-d2aaea4872c7", "title"=>"The 20/20 Experience"}, {"artists"=>[{"id"=>"596ffa74-3d08-44ef-b113-765d43d12738", "name"=>"Justin Timberlake"}], "secondarytypes"=>["Compilation"], "type"=>"Album", "id"=>"fe51b20f-83e4-49dd-9a36-b8d4da138325", "title"=>"The Complete 20/20 Experience"}, {"type"=>"Single", "id"=>"8f24e37b-5035-4383-89ff-818417f143e8", "title"=>"Suit & Tie"}], "title"=>"Suit & Tie", "id"=>"70003461-a6b3-4780-98e2-e1897cee0a7a"}], "score"=>0.968161, "id"=>"78dafd27-4c1f-4f99-9049-059bf39f666f"}, {"recordings"=>[{"artists"=>[{"joinphrase"=>" feat. ", "id"=>"596ffa74-3d08-44ef-b113-765d43d12738", "name"=>"Justin Timberlake"}, {"id"=>"f82bcf78-5b69-4622-a5ef-73800768d9ac", "name"=>"Jay-Z"}], "duration"=>326, "releasegroups"=>[{"artists"=>[{"id"=>"596ffa74-3d08-44ef-b113-765d43d12738", "name"=>"Justin Timberlake"}], "type"=>"Album", "id"=>"deae6fc2-a675-4f35-9565-d2aaea4872c7", "title"=>"The 20/20 Experience"}, {"artists"=>[{"id"=>"596ffa74-3d08-44ef-b113-765d43d12738", "name"=>"Justin Timberlake"}], "secondarytypes"=>["Compilation"], "type"=>"Album", "id"=>"fe51b20f-83e4-49dd-9a36-b8d4da138325", "title"=>"The Complete 20/20 Experience"}, {"type"=>"Single", "id"=>"8f24e37b-5035-4383-89ff-818417f143e8", "title"=>"Suit & Tie"}], "title"=>"Suit & Tie", "id"=>"70003461-a6b3-4780-98e2-e1897cee0a7a"}], "score"=>0.930842, "id"=>"6446d3af-61a5-48f9-beb2-4da2af9017f9"}]}
      response = Hashie::Mash.new(response)

      # list of albums under best recordings
      response.results[0].recordings[0].releasegroups
      # list of TITLES of best albums under recordings
      all_titles = response.results[0].recordings[0].releasegroups.collect(&:title)

      binding.pry


      response
    end
  end

  class Factory
    def self.generate(input, options={})
      if input.is_a? String
        path_to_file = input
      elsif input.is_a? CloudFile
        cloud_file = input
        path_to_file = input.path_to_file
      end

      extension = File.extname(path_to_file)
      file      = File.open(path_to_file)
      if extension.present?
        mime    = MimeMagic.by_extension(".m4a")
      else
        mime    = MimeMagic.by_magic(file)
      end

      klass     = Kernel.const_get("Tagger::#{mime.mediatype.titlecase}")
      klass.new(input, mime, file, options)
    end
  end


  class Base

    class << self
      def set_flags_via_path(path_to_file)
        if path_to_file.present? && (path_to_file.include?("/pronz") || path_to_file.include?("/peepshow"))
          {
            :peepy => true,
            :nsfw => true
          }
        else
          {}
        end
      end

      def parse_artist_string(value)
        return [] if value.blank?
        value.split("&").collect do |name|
          {:name => name.strip, :primary => true }
        end
      end
    
      def convert_primary_to_value(input)
        if input
          1
        else
          2
        end
      end
    end



    def initialize(input, mime, file, options={})
      if input.is_a? String
        @path_to_file = input
      elsif input.is_a? CloudFile
        @cloud_file   = input
        @path_to_file = input.path_to_file
      end

      @mime       = mime
      @file       = file
      @options    = options
      @attributes = {}
    end


    def save_data!
      return if @cloud_file.blank?

      if @release_attrs.compact.present?
        @release = Release.configure_and_save!(@release_attrs)
        @release_artists.each do |raw_artist|
          artist = Artist.configure_and_save! :name => raw_artist.name, :ext_id => raw_artist.ext_id, :data_source_id => @release.data_source_id
          ArtistRelease.find_or_create_by! :artist_id => artist.id, :release_id => @release.id, :relationship_id => Tagger::Base.convert_primary_to_value(raw_artist.primary)
        end

        @track_artists.each do |raw_artist|
          artist = Artist.configure_and_save! :name => raw_artist.name, :ext_id => raw_artist.ext_id, :data_source_id => @release.data_source_id
          ArtistCloudFile.find_or_create_by! :artist_id => artist.id, :cloud_file_id => @cloud_file.id, :relationship_id => Tagger::Base.convert_primary_to_value(raw_artist.primary)
        end

        @cloud_file.update_attributes(@cloud_file_attrs.merge(:release_id => @release.id))
      end
      
      @metadata.each do |key, value|
        label   = key.to_s.gsub("_", " ").titlecase
        type    = MetadataType.find_or_create_by!(:value => label)
        datum   = Metadatum.find_or_create_by!(:value => value, :user_id => @cloud_file.user_id, :metadata_type_id => type.id)
        Metatagging.find_or_create_by!(:metadatum_id => datum.id, :cloud_file_id => @cloud_file.id)
      end

      # Uploads release artwork
      if @artwork_data.present?
        temp_artwork = Tempfile.new(SecureRandom.uuid)
        temp_artwork.binmode
        temp_artwork.write(@artwork_data)
        CloudFileTaggerUploader.perform(temp_artwork.path, @cloud_file.bucket, :folder_id => @cloud_file.folder_id, :release_id => @cloud_file.release_id)
      end
    end
  end


  class Audio < Base
    def identify_and_update!
      identify
      save_data!
    end

    def best_matching_release
      if @id3_attr[:release].present? && @fingerprint.response.present?
        # use release if it was found via fuzzy, otherwise use other_release_sources
        release = @fingerprint.release if @fingerprint.found_via_fuzzy?
        release ||= other_release_sources
      elsif @id3_attr[:release].present?
        release = { :title => @id3_attr[:release] }
      elsif @fingerprint.release.present?
        release = @fingerprint.release
      else
        release = {}
      end
      release
    end

    # order of choice for release name after fuzzy matching fails
    # 1: id3 tag if _source is defined
    # 2: anything from API
    # 3: id3 tag
    # 4: empty hash
    def other_release_sources
      if @id3_attr[:_source].present?
        { :title => @id3_attr[:release] }
      elsif @fingerprint.response.present?
        @fingerprint.release.present?
      elsif @id3_attr[:release].present?
        { :title => @id3_attr[:release] } 
      else
        {}
      end      
    end

    def identify
      @id3_attr       = Hashie::Mash.new
      @fp_attr = {}
      ################
      #
      # Get Info via ID3
      id3_info        = ID3Tag.read(@file)
      
      if id3_info.artist.present?
        id3_artist = [{:name => id3_info.artist, :primary => true}]
      else
        id3_artist = []
      end

      @id3_attr[:_source]   = id3_info.get_frames(:PRIV).try(:first).try(:owner_identifier) #"www.amazon.com" o "PeakValue"
      @id3_attr[:artists]   = Tagger::Audio.parse_artist_string(id3_info.artist) #id3_artist
      @id3_attr[:title]     = id3_info.title.try(:strip)
      @id3_attr[:release]   = id3_info.album.try(:strip)
      @id3_attr[:year]      = id3_info.year
      @id3_attr[:track_num] = id3_info.track_nr
      @id3_attr[:genre]     = id3_info.genre
      @id3_attr[:comments]  = id3_info.comments.try(:strip)
      @artwork_data         = id3_info.get_frame(:APIC).try(:content)


      ################
      #
      # Get Info via AcouticFingerprint Service
      @fingerprint     = Fingerprinter.new(@id3_attr[:title], @id3_attr[:release], @path_to_file)
      @fingerprint.submit if @fingerprint.cleansed_fingerprint.present?

      @flags_via_path = Tagger::Audio.set_flags_via_path(@path_to_file)


      if @id3_attr[:_source].present?
        track_name   = @id3_attr[:title]
        release_name = @id3_attr[:release]
      else
        track_name   = @fingerprint.track.try(:title) || @id3_attr.title
      end

      track_id         = @fingerprint.track.try(:ext_id)
      release_id       = best_matching_release.try(:ext_id)
      release_name     = best_matching_release.try(:title) 
      @release_artists = @fingerprint.try(:release).try(:artists) || @id3_attr[:artists]
      @track_artists   = @fingerprint.try(:track).try(:artists) || @id3_attr[:artists]

      # creates hash to release metadata, nil values will be rmeoved.
      # is used by save_data fn
      # only created if we have valid release information
      if release_name || release_id
        @release_attrs = {
          :name => release_name,
          :ext_id => release_id,
          :data_source_id => 1
        }.merge(@flags_via_path).compact
      else
        @release_attrs = {}
      end

      # creates hash to store cloud file data, nil values will be rmeoved.
      # is used by save_data fn
      @cloud_file_attrs = {
        :name => track_name,
        :ext_id => track_id,
        :data_source_id => (track_id.present? ? 1 : nil),
        :release_pos => @id3_attr[:track_num],
        :year => @id3_attr[:year],
        :duration => @fingerprint.try(:duration)
      }.merge(@flags_via_path).compact

      # creates hash to store metadata, nil values will be rmeoved.
      # is used by save_data fn
      @metadata = Hashie::Mash.new({
        :genre => @id3_attr[:genre],
        :comments => @id3_attr[:comments],
        :acoustid_fingerprint => @fingerprint.try(:cleansed_fingerprint),
        :original_subpath => Folder.subpath(@path_to_file),
        :original_fullpath => @path_to_file,
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
