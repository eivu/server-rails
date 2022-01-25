class CloudFilesController < ApplicationController

  def show
    @cloud_file = CloudFile.seek(params[:id])
  end
end
