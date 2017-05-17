class ConfigurationsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: ::Configuration.all }
    end
  end

  def show
  end
end
