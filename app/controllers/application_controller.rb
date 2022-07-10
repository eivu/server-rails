class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #by default assume a user must be logged in
  before_action :authenticate_user!

  def peepy_value
    ActiveModel::Type::Boolean.new.cast(params[:peepy] || false)
  end

  def nsfw_value
    ActiveModel::Type::Boolean.new.cast(params[:nsfw] || false)
  end
end
