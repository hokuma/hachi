Pidgin::Engine.routes.draw do
  resources :resources, only: [:index, :show]
end
