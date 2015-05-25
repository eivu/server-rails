class ExternalsController < ApplicationController
  skip_before_filter :authenticate_user!

  def homepage
    redirect_to overview_path if user_signed_in?
  end
end
