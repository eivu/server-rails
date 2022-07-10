class CloudFilesController < ApplicationController

  def index
    @cloud_files = current_user.cloud_files
                               .where(peepy: peepy_value).alpha
                               .paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @cloud_file = CloudFile.seek(params[:id])
  end
end
