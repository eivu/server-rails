class Api::V1::FoldersController < Api::V1Controller
	skip_before_action :find_user

  def index
    render :json => { :status => 200, :status_msg => :ok, :data => TreeSerializer.build(nil) }
  end

  def show
  	render :json => { :status => 200, :status_msg => :ok, :data => TreeSerializer.build(Folder.find(params[:id])) }
  end
end
