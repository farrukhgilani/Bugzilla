# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'projects#index'

  resources :projects do
    resources :bugs do
    end
  end
end
