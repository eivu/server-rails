require 'rails_helper'

RSpec.describe Itunes::Library, type: :service do
  describe '#new' do
    let(:path_to_file) { "#{Rails.root}/spec/fixtures/files/itunes/library.xml" }

    subject { Itunes::Library.new(path_to_file) }

    it 'should have 4 tracks' do
      expect(subject.num_tracks).to eq(4)
    end

    it 'should return path to library' do
      expect(subject.path).to eq(path_to_file)
    end

    it 'should have an array of Itunes::Track objects' do
      subject.tracks.all? do |track|
        expect(track).to be_a(Itunes::Track)
      end
    end
  end
end