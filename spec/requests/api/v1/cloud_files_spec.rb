# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::CloudFiles', type: :request do
  let(:user) { create :user }

  describe 'POST /reserve' do
    subject(:make_reservation) { post "/api/v1/cloud_files/#{md5}/reserve/", params: params, headers: headers }

    let(:headers) { { Authorization: "Token #{user.token}" } }
    let(:bucket) { create(:bucket, user_id: user.id) }
    let(:fullpath) { Faker::File.dir }
    let(:md5) { Faker::Crypto.md5 }
    let(:num_of_folders_in_path) { fullpath.count('/') + 1 }
    let(:params) do
      {
        bucket_id: bucket.id,
        peepy: false,
        nsfw: true,
        fullpath: fullpath
      }
    end

    context 'valid reservation attributes' do
      scenario 'returns 200 OK' do
        make_reservation
        expect(response.status).to eq(200)
      end

      scenario 'file is in reserved state' do
        make_reservation
        expect(response.body).to include_json(state: 'reserved')
      end

      scenario 'file is owned by the current user' do
        make_reservation
        expect(response.body).to include_json(user_id: user.id)
      end

      scenario 'files attributes matches params' do
        make_reservation
        expect(response.body).to include_json(peepy: false, nsfw: true)
      end

      scenario 'folder has correct attributes' do
        make_reservation

        structured_data = Oj.load(response.body)
        folder = Folder.find(structured_data['folder_id'])
        aggregate_failures do
          expect(folder.peepy).to be(false)
          expect(folder.nsfw).to be(true)
        end
      end

      scenario 'correct number of folders were created in db' do
        expect { make_reservation }.to change(Folder, :count).by(num_of_folders_in_path)
      end
    end

    context 'invalid reservation attributes' do
      context 'md5 already exists' do
        before do
          CloudFile.create!(user_id: user.id, md5: md5, bucket_id: bucket.id, state: :reserved)
        end

        scenario 'returns 422 unprocessable entity' do
          make_reservation
          expect(response.status).to eq(422)
        end
      end

      context 'bucket is owned by another user' do
        let(:bucket) { create(:bucket) }

        scenario 'returns 401 unauthorized' do
          make_reservation
          expect(response.status).to eq(401)
        end
      end
    end
  end

  describe 'POST /transfer' do
    subject(:transfer_data) { post "/api/v1/cloud_files/#{md5}/transfer/", params: params, headers: headers }

    let(:md5) { cloud_file.md5 }
    let(:params) { Hash.new(content_type: content_type, asset: asset, filesize: filesize) }
    let(:content_type) { Faker::File.mime_type }
    let(:asset) { "#{Faker::Lorem.word.downcase}.#{content_type.split('/').last.gsub('+', '.')}" }
    let(:filesize) { rand(100.kilobytes..2.gigabytes) }

    context 'valid transfer attributes' do
      let!(:cloud_file) { create :cloud_file, :reserved, user: user }
      let(:headers) { { Authorization: "Token #{user.token}" } }
      let(:attributes) { params.merge(md5: cloud_file.md5, bucket_id: cloud_file.bucket_id) }

      scenario 'returns 200 OK' do
        transfer_data
        expect(response.status).to eq(200)
      end

      scenario 'file is owned by the current user' do
        transfer_data
        expect(response.body).to include_json(user_id: user.id)
      end

      scenario 'file is in transfered state' do
        transfer_data
        expect(response.body).to include_json(state: 'transfered')
      end

      scenario 'files attributes matches params and existing data' do
        transfer_data
        expect(response.body).to include_json(attributes)
      end

      scenario 'md5 did not change' do
        expect { transfer_data }.not_to change(cloud_file, :md5)
      end

      scenario 'user_id did not change' do
        expect { transfer_data }.not_to change(cloud_file, :user_id)
      end
    end

    context 'invalid transfer attributes' do
      context 'file is owned by another user' do
        let!(:cloud_file) { create :cloud_file, :reserved }
        let(:bucket) { create(:bucket) }

        scenario 'returns 401 unauthorized' do
          transfer_data
          expect(response.status).to eq(401)
        end
      end
    end
  end

  describe 'POST /complete' do
    subject(:complete_transfer) { post "/api/v1/cloud_files/#{md5}/complete/", params: params, headers: headers }

    context 'valid completion attributes' do
      let!(:cloud_file) { create :cloud_file, :transfered, user: user }
      let(:headers) { { Authorization: "Token #{user.token}" } }
      let(:md5) { cloud_file.md5 }
      let(:params) do
        {
          cloud_file_attributes: {
            year: rand(1965..Time.current.year),
            rating: rand(1.0..5.0).round(2),
            release_pos: rand(1..25)
          },
          matched_recording: generate_recording_data,
          tags: {
            genre: Faker::Music.genre,
            comment: Faker::Hipster.sentence
          }
        }
      end

      scenario 'returns 200 OK' do
        complete_transfer
        expect(response.status).to eq(200)
      end

      scenario 'fix complete_params' do
        raise 'artists are not included in release groups'
      end

      scenario 'file is in completed state' do
        complete_transfer
        expect(response.body).to include_json(state: 'completed')
      end

      scenario 'cloud file has correct attributes' do
        complete_transfer
        expect(cloud_file.reload).to have_attributes(params[:cloud_file_attributes])
      end

      scenario 'cloud file stores all data from acoustid' do
        raise('fix me: store data in matched_recording')
      end

      scenario 'tags have been saved properly' do
        complete_transfer
        raise 'fix me'
      end

      scenario 'md5 did not change' do
        expect { complete_transfer }.not_to change(cloud_file, :md5)
      end

      scenario 'user_id did not change' do
        expect { complete_transfer }.not_to change(cloud_file, :user_id)
      end
    end
  end
end
