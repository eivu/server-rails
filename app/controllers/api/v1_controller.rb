# frozen_string_literal: true

module Api
  class V1Controller < ApplicationController
    skip_before_action :verify_authenticity_token, :authenticate_user!
    before_action :authenticate_by_token

    # rescue_from ActiveRecord::RecordNotFound, with: :render404
    # rescue_from StandardError do |e|
    #   render json: { message: e.message }, status: 500
    # end


    def info
      render json: { version: '0.2.3' }
    end

    ############################################################################
    private
    ############################################################################

    # def render404
    #   render json: { message: 'no cloud file exists with that md5' }, status: 404
    # end

    def authenticate_by_token
      authenticate_or_request_with_http_token do |token, options|
        user = User.find_by_token(token)
        # Compare the tokens in a time-constant manner, to mitigate timing attacks.
        @current_user = user if user && ActiveSupport::SecurityUtils.secure_compare(token, user&.token)
      end
    end
  end
end
