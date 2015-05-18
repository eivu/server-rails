class OverviewController < ApplicationController
  before_filter :authenticate_user!

  def show
    @folder_roots = Folder.roots
  end
end
