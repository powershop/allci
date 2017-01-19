Rails.application.routes.draw do
  post '/webhooks/github' => 'webhooks#github'
  post '/webhooks/gitlab' => 'webhooks#gitlab'

  post '/tasks/pull' => 'tasks#pull'
  post '/tasks/success' => 'tasks#success'
  post '/tasks/failed' => 'tasks#failed'
end
