class BuildTasksController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: BuildTask.all }
    end
  end

  def show
  end
end
