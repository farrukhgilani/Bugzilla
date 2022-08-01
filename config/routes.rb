Rails.application.routes.draw do
  devise_for :users

  root to: 'projects#index'

  resources :projects do
    resources :bugs
  end

  resources :bugs, only: %i[insert_id] do
    member do
      get 'insert_id', to: 'bugs#insert_id'
      get 'bug_resolved', to: 'bugs#bug_resolved'
    end

  end

end
