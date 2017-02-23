Rails.application.routes.draw do
  post '/webhooks/github' => 'webhooks#github'
  post '/webhooks/gitlab' => 'webhooks#gitlab'

  post '/tasks/pull' => 'tasks#pull'
  post '/tasks/output' => 'tasks#output'
  post '/tasks/success' => 'tasks#success'
  post '/tasks/failed' => 'tasks#failed'
  post '/tasks/add' => 'tasks#add'
end
