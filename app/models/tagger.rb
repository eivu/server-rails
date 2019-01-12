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
      klass.new(mime, cloud_file)
    end
  end

  class Base
    def initialize(mime, cloud_file)
      @mime       = mime
      @cloud_file = cloud_file
    end

    def set_flags_via_path
      binding.pry
    end
  end

  class Audio < Base
    def inspect!
      binding.pry
      fingerprint = Fingerprinter.new(path_to_file)
      identifier  = fingerprint.cleansed_fingerprint
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
