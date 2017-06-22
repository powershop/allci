Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get 'projects/index'

  post '/webhooks/github' => 'webhooks#github'
  post '/webhooks/gitlab' => 'webhooks#gitlab'

  post '/tasks/pull' => 'tasks#pull'
  post '/tasks/output' => 'tasks#output'
  post '/tasks/success' => 'tasks#success'
  post '/tasks/failed' => 'tasks#failed'
  post '/tasks/add' => 'tasks#add'

  resources :labels
  resources :projects
  resources :configurations
  resources :configuration_builds
  resources :build_tasks
  resources :build_task_runs
  resource :burndowns

  root to: 'projects#index'
end
