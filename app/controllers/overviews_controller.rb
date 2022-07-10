class OverviewsController < ApplicationController
  def show
    @folders = Folder.roots.where(peepy: peepy_value).alpha
    # @folders = Folder.includes(:cloud_files, bucket: [:region]).roots.alpha
  end
end
