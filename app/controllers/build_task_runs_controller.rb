class BuildTaskRunsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def show
    @build_task_run = BuildTaskRun.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'burndowns' }
    end
  end
end
