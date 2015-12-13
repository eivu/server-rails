class Api::V1::CloudFilesController < Api::V1Controller


  def authorize
    if current_user.cloud_files.where(:md5 => params[:id]).blank?
      render :json => { :status => :ok, :message => "proceed with upload" }
    else
      render :json => { :status => :error, :message => "file already exists w/ md5 #{params[:id]}" }, :status => :unauthorized
    end
  end

end
