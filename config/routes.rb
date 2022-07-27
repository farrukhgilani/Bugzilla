Rails.application.routes.draw do
  devise_for :users
  # get 'bugs/create'
  # get 'bugs/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'projects#index'
  # get 'index', to: 'user#index', as: 'index'

  resources :projects do
    resources :bugs
  end

  resources :bugs, only: %i[insert_id] do
    member do
      put 'insert_id', to: 'bugs#insert_id'
      put 'bug_resolved', to: 'bugs#bug_resolved'
    end

  end

end
