require 'rails_helper'

RSpec.describe 'Api::V1::CloudFiles', type: :request do
  let(:user) { create :user }

  before {
    @user = user
  }

  describe 'GET /index' do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe 'POST /reserve' do
    subject(:make_reservation) { post "/api/v1/cloud_files/#{md5}/reserve/", headers: headers }

    context 'valid reservation attributes' do
      let(:headers) { { Authorization: "Token #{user.token}" } }
      let(:md5) { Faker::Crypto.md5 }

      scenario 'returns 200 OK' do
        make_reservation
        expect(response.status).to eq(200)
      end
    end
  end
end
