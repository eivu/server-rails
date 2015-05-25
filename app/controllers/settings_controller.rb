class SettingsController < ApplicationController

  before_filter :set_left_nav_dir

  ############################################################################
  private
  ############################################################################

  def set_left_nav_dir
    @left_nav_dir = "settings"
  end
end
