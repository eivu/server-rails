class OverviewsController < ApplicationController
  def show
    @folders = Folder.roots.alpha
    @folder = Folder.last
    # @folder_roots = Folder.includes(:cloud_files, bucket: [:region]).roots
  end
end
