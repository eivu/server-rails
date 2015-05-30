class RegionsController < ApplicationController

  def index
    @columns = %w(descr name endpoint location)
    @regions = Region.all
  end
end
