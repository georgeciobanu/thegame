class AreasController < ApplicationController
  def index
    render :json => Area.all
  end
end
