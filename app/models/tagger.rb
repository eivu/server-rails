module Tagger


  class Test
    def self.run
      cloud_file = Bucket.last.cloud_files.last
      cloud_file.path_to_file = "/Users/jinx/Dropbox/eivu/sample/Sound Effects/Cow-SoundBible.com-868293659.mp3"
      Tagger::Factory.generate(cloud_file).inspect!
    end
  end

  class Factory
    def self.generate(cloud_file)
      file      = File.open(cloud_file.path_to_file)
      mime      = MimeMagic.by_magic(file)
      klass     = Kernel.const_get("Tagger::#{mime.mediatype.titlecase}")
      klass.new(cloud_file, mime, file)
    end
  end

  class Base
    def initialize(cloud_file, mime, file)
      @mime       = mime
      @file       = file
      @cloud_file = cloud_file
      @attributes = {}
    end

    def set_flags_via_path
      binding.pry
    end
  end


  class Audio < Base
    def inspect!
      ################
      #
      # Get Info via ID3
      id3_info        = ID3Tag.read(@file)
      @attributes[:primary_artist] = id3_info.artist
      @attributes[:title]          = id3_info.title
      @attributes[:release]        = id3_info.album
      @attributes[:year]           = id3_info.year
      @attributes[:track_num]      = id3_info.track_nr
      @attributes[:genre]          = id3_info.genre
      @attributes[:comments]       = id3_info.comments
      @attributes[:artwork]        = id3_info.get_frame(:APIC).try(:content)


      ################
      #
      # Get Info via AcouticFingerprint Service
      fingerprint     = Fingerprinter.new(@cloud_file.path_to_file)
      fingerprint.submit if fingerprint.cleansed_fingerprint.present?
        
      binding.pry
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
