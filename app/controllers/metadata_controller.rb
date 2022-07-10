class MetadataController < ApplicationController

  def index
    @metadata = current_user.metadata.human_readable.includes(:type).where(peepy: peepy_value).alpha
  end

  def update
    metadatum = Metadatum.find(params[:id])
    metadatum.toggle_expansion

    respond_to do |format|
      # Hotwire Implenation
      format.turbo_stream  { render turbo_stream: turbo_stream.update(metadatum) }
      format.html #{ redirect_to messages_url }
    end
  end
end
