class OverviewsController < ApplicationController
  def show
    @folders = Folder.roots.alpha
    # @folder_roots = Folder.includes(:cloud_files, bucket: [:region]).roots
  end
end
