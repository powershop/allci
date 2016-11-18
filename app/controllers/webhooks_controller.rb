class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def github
    if request.headers['X-GitHub-Event'] == 'push'
      ProcessGitHubPushEvent.new(request.body.read).call
    end
  end

  def gitlab
    if request.headers['X-Gitlab-Event'] == 'Push Hook'
      ProcessGitLabPushEvent.new(request.body.read).call
    end
  end
end
