class Api::V1::CloudFilesController < Api::V1Controller

  def authorize
    if current_user.cloud_files.where(:md5 => params[:id]).blank?
      render :json => { :status => 200, :status_msg => :ok, :message => "proceed with upload" }
    else
      render :json => { :status_msg => :error, :message => "file already exists w/ md5 #{params[:id]}" }, :status => :unauthorized
    end
  end

end
