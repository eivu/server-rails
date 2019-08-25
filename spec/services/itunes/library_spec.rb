require 'rails_helper'

RSpec.describe Itunes::Library, type: :service do
  describe 'new instance' do
    let(:path_to_file) { "#{Rails.root}/spec/fixtures/files/itunes/library.xml" }

    subject { Itunes::Library.new(path_to_file) }

    specify '#num_tracks to have 4 tracks' do
      expect(subject.num_tracks).to eq(4)
    end

    specify '#path to return path to library' do
      expect(subject.path).to eq(path_to_file)
    end

    specify '#tracks to be an array of Itunes::Track objects' do
      subject.tracks.all? do |track|
        expect(track).to be_a(Itunes::Track)
      end
    end

    specify '#raw_tracks to be an array of hashes' do
      subject.raw_tracks.all? do |raw_track|
        expect(raw_track).to be_a(Hash)
      end
    end
  end
end