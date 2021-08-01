class OverviewsController < ApplicationController
  def show
    @folder_roots = Folder.includes(:cloud_files, bucket: [:region]).roots
  end
end
