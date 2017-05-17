class ConfigurationBuildsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: ConfigurationBuild.all }
    end
  end

  def show
  end
end
