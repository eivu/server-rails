class FoldersController < ApplicationController

  def update
    folder = Folder.find(params[:id])
    folder.toggle_expansion

    respond_to do |format|
      format.turbo_stream  { render turbo_stream: turbo_stream.update(folder) }
      format.html #{ redirect_to messages_url }
    end
  end
end
