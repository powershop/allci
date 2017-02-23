Rails.application.routes.draw do
  get 'projects/index'

  post '/webhooks/github' => 'webhooks#github'
  post '/webhooks/gitlab' => 'webhooks#gitlab'

  post '/tasks/pull' => 'tasks#pull'
  post '/tasks/output' => 'tasks#output'
  post '/tasks/success' => 'tasks#success'
  post '/tasks/failed' => 'tasks#failed'

  resources :projects
  root to: 'projects#index'
end
