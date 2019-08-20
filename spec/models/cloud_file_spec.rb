require 'rails_helper'

RSpec.describe CloudFile, type: :model do
  # before { create :bucket, id: 1 }
  before { Bucket.create! id: 1 }

  it '#foo' do
    VCR.use_cassette('scratch/tests', record: :once) do
      # lib = ItunesLibrary.new
      # track_info = lib.raw_tracks[759]
      path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/Kanye\ West/Late\ Registration/15\ Skit\ \#3.mp3"
      tagger = Tagger::Factory.generate(path)
      tagger.identify
      binding.pry
    end
  end
end
