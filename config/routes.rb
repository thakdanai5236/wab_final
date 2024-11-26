Rails.application.routes.draw do
  # Root path
  root "posts#index"  # หน้าแรกของเว็บไซต์

  # Define routes for static pages
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"

  # Routes for resources
  resources :comments
  resources :likes, only: [:create, :destroy]
  resources :posts

  # Routes for Devise user authentication
  devise_for :users
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    get '/users/password', to: 'devise/passwords#new'
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  # Custom route for "My Posts" page
  get "my_posts", to: "posts#myposts", as: 'my_posts'

  # Search route for posts
  get "posts/search", to: "posts#search", as: :search_posts

  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check

  # Route to remove duplicate posts
  delete "posts/remove_duplicates", to: "posts#remove_duplicates", as: :remove_duplicates
end
