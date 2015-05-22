class ExternalsController < ApplicationController

  def homepage
    redirect_to overview_path if user_signed_in?
  end
end
