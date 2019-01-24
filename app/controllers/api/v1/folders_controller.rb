class Api::V1::FoldersController < Api::V1Controller

  def index
    render :json => { :status => 200, :status_msg => :ok, :data => Folder.roots.collect{|f| f.subtree.arrange_serializable }}
  end
end
