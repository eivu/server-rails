# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe '.find_or_create_from_path' do
    subject(:instance) {
      described_class.find_or_create_from_path(fullpath: path, bucket_id: bucket_id, peepy: peepy, nsfw: nsfw)
    }

    let(:bucket_id) { 17 }
    let(:nsfw) { false }
    let(:peepy) { false }

    context 'nsfw and peey is true' do
      let(:path) { 'other' }
      let(:nsfw) { true }
      let(:peepy) { true }

      it 'creates a single folder' do
        expect { instance }.to change(Folder, :count).by(1)
      end

      it 'creates a folder named other' do
        expect(instance.name).to eq('other')
      end

      it 'creates a folder that is nsfw and peepy' do
        expect(instance).to have_attributes(nsfw: true, peepy: true)
      end
    end

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

    context 'double nested folder' do
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
        let!(:parent) { Folder.create name: 'folder_a', bucket_id: bucket_id }

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

    context 'triple nested folder' do
      let(:path) { 'folder_a/folder_b/folder_c' }

      context 'folder_a does NOT exist' do
        it 'creates two folders' do
          expect { instance }.to change(Folder, :count).by(3)
        end

        it 'creates a folder named folder_c' do
          expect(instance.name).to eq('folder_c')
        end

        it 'has a parent named folder_b' do
          expect(instance.parent.name).to eq('folder_b')
        end

        it 'has a grandparent named folder_c' do
          expect(instance.parent.parent.name).to eq('folder_a')
        end
      end
    end
  end
end
