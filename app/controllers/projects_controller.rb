class ProjectsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: Project.all }
    end
  end
end
