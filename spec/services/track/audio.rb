require 'rails_helper'

RSpec.describe Track::Audio, type: :service do
  describe 'new instance' do
    let(:raw_track) { {'Track ID'=>103, 'Name'=>'Dust and Memories', 'Artist'=>'Unheard Music Concepts', 'Album Artist'=>'Unheard Music Concepts', 'Album'=>'The Lasso of Time', 'Genre'=>'Jazz', 'Kind'=>'MPEG audio file', 'Size'=>3891397, 'Total Time'=>121573, 'Track Number'=>13, 'Year'=>2019, 'Date Modified'=>Date.parse('Sun, 25 Aug 2019 19:18:37 +0000'), 'Date Added'=>Time.parse('Sun, 25 Aug 2019 19:22:43 +0000'), 'Bit Rate'=>256, 'Sample Rate'=>44100, 'Comments'=>"URL: http://freemusicarchive.org/music/Unheard_Music_Concepts/The_Lasso_of_Time/Dust_and_Memories\nComments: http://freemusicarchive.org/\nCurator: \nCopyright: Attribution: http://creativecommons.org/licenses/by/4.0/", 'Sort Album'=>'Lasso of Time', 'Persistent ID'=>'C85D334586004BEF', 'Track Type'=>'File', 'Location'=>"Music/Unheard%20Music%20Concepts/The%20Lasso%20of%20Time/13%20Dust%20and%20Memories.mp3", 'File Folder Count'=>5, 'Library Folder Count'=>1} }

    subject { Track::Audio.new(raw_track) }

    specify '#path_to_file to exists' do
      path = URI.decode("#{Rails.root}/spec/fixtures/files/itunes/#{subject.path_to_file}")
      expect(File.exist?(path)).to be true
    end
  end
end