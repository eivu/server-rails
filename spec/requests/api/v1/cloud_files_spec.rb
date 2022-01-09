# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::CloudFiles', type: :request do
  let(:user) { create :user }

  describe 'POST /reserve' do
    subject(:make_reservation) { post "/api/v1/cloud_files/#{md5}/reserve/", params: params, headers: headers }

    let(:headers) { { Authorization: "Token #{user.token}" } }
    let(:md5) { Faker::Crypto.md5 }
    let(:bucket) { create(:bucket, user_id: user.id) }
    let(:params) {
      {
        bucket_id: bucket.id,
        folder: {
          fullpath: Faker::File.dir,
          bucket_id: rand(1..17),
          peepy: false,
          nsfw: true
        }
      }
    }

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
        expect(response.body).to include_json(params)
      end

      scenario 'folder has correct attributes' do
        make_reservation
        raise 'fix me'
      end

      scenario 'correct number of folders were created in db' do
        make_reservation
        raise 'fix me'
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

    context 'valid reservation attributes' do
      let!(:cloud_file) { create :cloud_file, :reserved }
      let(:headers) { { Authorization: "Token #{user.token}" } }
      let(:md5) { cloud_file.md5 }
      let(:content_type) { Faker::File.mime_type }
      let(:asset) { "#{Faker::Lorem.word.downcase}.#{content_type.split('/').last.gsub('+', '.')}" }
      let(:filesize) { rand(100.kilobytes..2.gigabytes) }
      let(:params) do
        { content_type: content_type, asset: asset, filesize: filesize }
      end
      let(:attributes) do
        params.merge(md5: cloud_file.md5, bucket_id: cloud_file.bucket_id)
      end

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
    end
  end

  describe 'POST /complete' do
    subject(:complete_transfer) { post "/api/v1/cloud_files/#{md5}/complete/", params: params, headers: headers }

    context 'valid completion attributes' do
      let!(:cloud_file) { create :cloud_file, :transfered }
      let(:headers) { { Authorization: "Token #{user.token}" } }
      let(:md5) { cloud_file.md5 }
      let(:content_type) { Faker::File.mime_type }
      let(:asset) { "#{Faker::Lorem.word.downcase}.#{content_type.split('/').last.gsub('+', '.')}" }
      let(:filesize) { rand(100.kilobytes..2.gigabytes) }
      let(:params) do
        {
          cloud_file_attributes: {
            year: rand(1965..Time.current.year),
            rating: rand(1..5),
            release_pos: rand(1..25),
            content_type: content_type
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
        expect(response.body).to include_json(state: 'completed')
      end

      scenario 'tags have been saved properly' do
        complete_transfer
        raise 'fix me'
      end

      scenario 'md5 did not change' do
        complete_transfer
        raise 'fix me'
      end

      scenario 'user_id did not change' do
        complete_transfer
        raise 'fix me'
      end
    end
  end
end
