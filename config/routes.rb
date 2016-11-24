Pidgin::Engine.routes.draw do
  resources :resources, only: [:index, :show]
  get '/links/:method/*href', to: 'links#show'
  post '/links/:method/*href', to: 'links#client'
end
