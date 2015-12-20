class Api::V1::CloudFilesController < Api::V1Controller

  def create
    begin
      #just querying to make sure the user owns the bucket. if a user's bucket isn't found this will raise an error
      current_user.buckets.find(params[:cloud_file][:bucket_id])
      params[:cloud_file][:folder_id] = nil if params[:preserve_tree].blank?
      cloud_file = CloudFile.create! params.require(:cloud_file).permit(:name, :asset, :md5, :content_type, :filesize, :description, :rating, :nsfw, :bucket_id, :folder_id, :info_url)
      render(:json => { :status => 200, :status_msg => :ok, :message => "#{cloud_file.asset} has been uploaded to #{cloud_file.url}" })
    rescue Exception => error
      render(:json => { :status_msg => :error, :message => error.message }, :status => :unauthorized)
    end
  end


  def authorize
    if current_user.cloud_files.where(:md5 => params[:id]).blank?
      render :json => { :status => 200, :status_msg => :ok, :message => "proceed with upload" }
    else
      render :json => { :status_msg => :error, :message => "file already exists w/ md5 #{params[:id]}" }, :status => 400
    end
  end

end
