# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::CloudFiles', type: :request do
  let(:user) { create :user }

  describe 'POST /reserve' do
    subject(:make_reservation) { post "/api/v1/cloud_files/#{md5}/reserve/", params: params, headers: headers }

    context 'valid reservation attributes' do
      let(:headers) { { Authorization: "Token #{user.token}" } }
      let(:md5) { Faker::Crypto.md5 }
      let(:bucket_id) { rand(1..17) }
      let(:params) { { bucket_id: bucket_id } }

      scenario 'returns 200 OK' do
        make_reservation
        expect(response.status).to eq(200)
      end

      scenario 'file is in reserved state' do
        make_reservation
        expect(response.body).to include_json(state: 'reserved')
      end

      scenario 'files attributes matches params' do
        make_reservation
        expect(response.body).to include_json(params)
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
end
