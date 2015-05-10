class CloudFilesController < ApplicationController

  def edit
    @cloud_file = CloudFile.find(params[:id])
  end
end
