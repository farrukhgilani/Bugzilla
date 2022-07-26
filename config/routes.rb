Rails.application.routes.draw do
  devise_for :users
  get 'bugs/create'
  get 'bugs/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'projects#index'
  get 'index', to: 'user#index', as: 'index'

  resources :projects do
    resources :bugs
  end
end
