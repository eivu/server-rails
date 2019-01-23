class Api::V1Controller < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!#, if: :json_request?
  before_action :find_user

  ############################################################################
  private
  ############################################################################

  def json_request?
    request.format.json?
  end

  def find_user
    user = User.find_by_token(params[:token])
    if user.present?
      sign_in(user)
    else
      render :json => { :error => "Can not find a user with token '#{params[:token]}'" }, :status => :unauthorized
    end
  end

end
