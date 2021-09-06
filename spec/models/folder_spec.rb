require 'rails_helper'

RSpec.describe Folder, type: :model do

  describe '.create_from_path' do
    subject(:instance) { described_class.create_from_path(path) }

    context 'empty string' do
      let(:path) { '' }

      it 'creates no new folders' do
        expect { instance }.not_to change(Folder, :count)
      end

      it 'returns nil' do
        expect(instance).to be nil
      end
    end

    context nil do
      let(:path) { nil }

      it 'creates no new folders' do
        expect { instance }.not_to change(Folder, :count)
      end

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
        expect(instance.name).to eq('folder_a')
      end
    end

    context 'doubley nested folder' do
      let(:path) { 'folder_a/folder_b' }

      context 'folder_a does NOT exist' do
        it 'creates two folders' do
          expect { instance }.to change(Folder, :count).by(2)
        end

        it 'creates a folder named folder_b' do
          expect(instance.name).to eq('folder_b')
        end

        it 'has a parent named folder_a' do
          expect(instance.parent.name).to eq('folder_a')
        end
      end

      context 'folder_a does exist' do
        let!(:parent) { Folder.create name: 'folder_a' }

        it 'creates a single folder' do
          expect { instance }.to change(Folder, :count).by(1)
        end

        it 'creates a folder named folder_b' do
          expect(instance.name).to eq('folder_b')
        end

        it 'has a parent named folder_a' do
          expect(instance.parent.name).to eq('folder_a')
        end

        it 'has a parent that id matches the existing folder' do
          expect(instance.parent).to eq(parent)
        end
      end
    end
  end
end
