class ProjectsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: Project.with_labels, include: :labels }
    end
  end

  def show
  end
end
