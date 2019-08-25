require 'openssl'
   OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

require 'rails_helper'



require 'rubygems'
# require 'test/unit'
require 'vcr'



VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end


RSpec.describe CloudFile, type: :model do
  # before { create :bucket, id: 1 }
  before { Bucket.create! id: 1 }

  it '#foo' do
    # VCR.use_cassette('scratch/acoustid/watch_the_throne-lift_off', record: :once) do
    # VCR.use_cassette('scratch/acoustid/kanye-west-skit_3', record: :once) do
    VCR.use_cassette('acoustid/alica', record: :once) do
      # lib = ItunesLibrary.new
      # track_info = lib.raw_tracks[759]
      # path = "/Users/jinx/Dropbox/eivu/sample/Jay-Z\ \&\ Kanye\ West/Watch\ The\ Throne\ \(Deluxe\ Edition\)\ \[Explicit\]/01-02-\ Lift\ Off\ \[feat\ Beyoncé\]\ \[Explicit\].mp3"
      # path = "/Users/jinx/Music/iTunes/iTunes\ Media/Music/Kanye\ West/Late\ Registration/15\ Skit\ \#3.mp3"
      path = "/Users/jinx/Dropbox/eivu/sample/Mala/Alicia/01\ Alicia.mp3"
      tagger = Tagger::Factory.generate(path)
      tagger.identify
    end
  end
end

# parse artists
# [{"id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "name"=>"Kanye West"}]

# [{"id"=>"f82bcf78-5b69-4622-a5ef-73800768d9ac", "joinphrase"=>" & ", "name"=>"JAY Z"},
#  {"id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "joinphrase"=>" feat. ", "name"=>"Kanye West"},
#  {"id"=>"859d0860-d480-4efd-970c-c05d5f1776b8", "name"=>"Beyoncé"}]