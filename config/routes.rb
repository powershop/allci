Rails.application.routes.draw do
  post '/webhooks/github' => 'webhooks#github'
  post '/webhooks/gitlab' => 'webhooks#gitlab'

  post '/tasks/pull' => 'tasks#pull'
end
