class MetadataController < ApplicationController

  def index
    @metadata = current_user.metadata.human_readable.includes(:metadata_type).where(peepy: peepy_value).alpha
  end

  def peepy_value
    ActiveModel::Type::Boolean.new.cast(params[:peepy] || false)
  end

  def nsfw_value
    ActiveModel::Type::Boolean.new.cast(params[:nsfw] || false)
  end
end
