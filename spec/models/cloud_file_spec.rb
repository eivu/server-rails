require 'rails_helper'

RSpec.describe CloudFile, type: :model do
  describe '#metadata_list=' do
    subject(:tagging) { cloud_file.metadata_list = list }

    context 'when working with a plain cloud file' do
      let(:cloud_file) { create(:cloud_file, :transfered) }
      let(:list) { { genre: 'jazz', tag: 'great' } }

      it 'should save the data' do
        tagging
        expect(cloud_file.metadata).to contain_exactly(
          an_object_having_attributes(
            value: 'jazz',
            peepy: false,
            nsfw: false,
            user_id: cloud_file.user_id,
            metadata_type: an_object_having_attributes(value: 'genre')
          ),
          an_object_having_attributes(
            value: 'great',
            user_id: cloud_file.user_id,
            metadata_type: an_object_having_attributes(value: 'tag')
          )
        )
      end
    end

    context 'when working with a peepy cloud file' do
      let(:cloud_file) { create(:cloud_file, :transfered, :peepy) }
      let(:list) { { dirty: 'bird' } }

      it 'should save the data' do
        tagging
        expect(cloud_file.metadata).to contain_exactly(
          an_object_having_attributes(
            value: 'bird',
            user_id: cloud_file.user_id,
            peepy: true,
            nsfw: false,
            metadata_type: an_object_having_attributes(value: 'dirty')
          )
        )
      end
    end

    context 'when working with a nsfw cloud file' do
      let(:cloud_file) { create(:cloud_file, :transfered, :nsfw) }
      let(:list) { { loud: 'rap' } }

      it 'should save the data' do
        tagging
        expect(cloud_file.metadata).to contain_exactly(
          an_object_having_attributes(
            value: 'rap',
            user_id: cloud_file.user_id,
            peepy: false,
            nsfw: true,
            metadata_type: an_object_having_attributes(value: 'loud')
          )
        )
      end
    end

    context 'when working with a nsfw and peepy cloud file' do
      let(:cloud_file) { create(:cloud_file, :transfered, :nsfw, :peepy) }
      let(:list) { { naughty: 'bits' } }

      it 'should save the data' do
        tagging
        expect(cloud_file.metadata).to contain_exactly(
          an_object_having_attributes(
            value: 'bits',
            user_id: cloud_file.user_id,
            nsfw: true,
            peepy: true,
            metadata_type: an_object_having_attributes(value: 'naughty')
          )
        )
      end
    end
  end
end
