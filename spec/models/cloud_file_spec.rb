require 'rails_helper'

RSpec.describe CloudFile, type: :model do
  let(:cloud_file) { create(:cloud_file, :transfered) }
  let(:list) { Hash.new(genre: 'jazz', tag: 'great') }

  describe '#metadata_list=' do
    context 'when building a new CloudFile' do
      subject(:tagging) { cloud_file.metadata_list = list }

      it 'should not save metadata records, only build them' do
        expect { tagging }.to not_change { Metadatum.count }.and(not_change { Metatagging.count })
      end

      it 'should return an array of metadatum records' do
        expect(tagging).to all(be_a(Metadatum))
      end

      it 'should build the proper data' do
        tagging
 
        # expect(cloud_file.metadata).to contain_exactly(
        #   an_object_having_attributes(genre: 'jazz'),
        # )
      end
    end
  end
end
