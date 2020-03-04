Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/create', to: 'game#create'
  post '/input/:knocked_pins', to: 'game#input'

  get '/scores', to: 'game#scores'
end
