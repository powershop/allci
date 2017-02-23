class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :render_application, unless: :performed?
  rescue_from ActionController::UnknownFormat, with: :try_to_render_application

  private

  def render_application
    render text: '', layout: true
  end

  def try_to_render_application(exception)
    if request.format.html?
      render_application
    else
      raise exception
    end
  end
end
