class SettingsController < ApplicationController

  before_action :set_left_nav_dir

  ############################################################################
  private
  ############################################################################

  def set_left_nav_dir
    @left_nav_dir = "settings"
  end
end
