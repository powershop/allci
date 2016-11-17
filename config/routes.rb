Rails.application.routes.draw do
  get '/webhooks/github' => 'webhooks#github'
  get '/webhooks/gitlab' => 'webhooks#gitlab'
end
