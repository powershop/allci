class LabelsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: Label.alphabetically }
    end
  end
end
