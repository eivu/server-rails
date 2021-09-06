require 'rails_helper'

RSpec.describe Folder, type: :model do

  describe '.create_from_path' do
    subject(:instance) { described_class.create_from_path(path) }

    context 'empty string' do
      let(:path) { '' }

      it 'returns nil' do
        expect(instance).to be nil
      end
    end

    context nil do
      let(:path) { nil }

      it 'returns nil' do
        expect(instance).to be nil
      end
    end

    context 'single folder' do
      let(:path) { 'folder_a' }

      it 'creates a single folder' do
        expect { instance }.to change(Folder, :count).by(1)
      end

      it 'creates a folder named folder_a' do
        expect(instance.name).to eq(path)
      end
    end
  end
end
