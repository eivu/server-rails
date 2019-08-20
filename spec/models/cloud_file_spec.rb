require 'rails_helper'

RSpec.describe CloudFile, type: :model do
  # before { create :bucket, id: 1 }
  before { Bucket.create! id: 1 }

  it '#foo' do
    VCR.use_cassette('scratch/tests', record: :once) do
      # lib = ItunesLibrary.new
      # track_info = lib.raw_tracks[759]
      path = "/Users/jinx/Dropbox/eivu/sample/Jay-Z\ \&\ Kanye\ West/Watch\ The\ Throne\ \(Deluxe\ Edition\)\ \[Explicit\]/01-02-\ Lift\ Off\ \[feat\ Beyoncé\]\ \[Explicit\].mp3"
      # path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/Kanye\ West/Late\ Registration/15\ Skit\ \#3.mp3"
      tagger = Tagger::Factory.generate(path)
      tagger.identify
      binding.pry
    end
  end
end

# parse artists
# [{"id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "name"=>"Kanye West"}]

# [{"id"=>"f82bcf78-5b69-4622-a5ef-73800768d9ac", "joinphrase"=>" & ", "name"=>"JAY Z"},
#  {"id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "joinphrase"=>" feat. ", "name"=>"Kanye West"},
#  {"id"=>"859d0860-d480-4efd-970c-c05d5f1776b8", "name"=>"Beyoncé"}]