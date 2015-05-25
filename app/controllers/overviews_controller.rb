class OverviewsController < ApplicationController

  def show
    @folder_roots = Folder.roots
  end
end
