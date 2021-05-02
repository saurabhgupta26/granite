Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # resources :tasks, only: [:index, :create], param: :slug
  # resources :tasks, except: %i[new edit], param: :slug
  resources :tasks, except: %i[new edit]
  resources :users, only: %i[create index]
  resources :sessions, only: [:create, :destroy]
  resources :comments, only: :create

  root "home#index"
  get '*path', to: 'home#index', via: :all
end
