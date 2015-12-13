class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception, :unless => :api_request?
  #by default assume a user must be logged in
  before_filter :authenticate_user!, :unless => :api_request?


  ############################################################################
  private
  ############################################################################

  def api_request?
    request.path.start_with? "/api"
  end


end
