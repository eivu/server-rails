class OverviewsController < ApplicationController
  def show
    @folders = Folder.roots.alpha
    # @folders = Folder.includes(:cloud_files, bucket: [:region]).roots.alpha
  end
end
